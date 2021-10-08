tool
extends Spatial

export var max_bounces: int = 3
export var cast_length: float = 10.0

var laser: Spatial
var laser_line: Node
var normal_line: Node
var tangent_line: Node

func _init():
	if not Engine.editor_hint:
		return
	set_process(true)
	set_physics_process(true)
	laser = get_node("Laser")
	laser_line = get_node("LaserLine")
	normal_line = get_node("NormalLine")
	tangent_line = get_node("TangentLine")

func _ready():
	laser = get_node("Laser")
	laser_line = get_node("LaserLine")
	normal_line = get_node("NormalLine")
	tangent_line = get_node("TangentLine")

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	shoot_laser(space_state)

func shoot_laser(space_state):
	# initial raycast
	laser_line.points.clear()
	laser_line.points.append(laser.transform.origin)
	var raycastStart = laser.transform.origin
	var raycastEnd = laser.transform.origin + laser.transform.basis.z.normalized() * cast_length
	var hit = space_state.intersect_ray(raycastStart, raycastEnd)
	laser_line.points.append(hit.position if hit else raycastEnd)
	normal_line.points.clear()
	if not hit:
		normal_line.visible = false
		tangent_line.visible = false
		return
	# draw normal vector on sphere, if hit
	normal_line.visible = true
	tangent_line.visible = true
	normal_line.points.append(hit.position)
	normal_line.points.append(hit.position + hit.normal)
	# compute the tangent vector to the hit surface
	var incident = raycastEnd - raycastStart
	var cross_vec = incident.cross(hit.normal)
	var tangent_vec = hit.normal.cross(cross_vec).normalized()
	# draw tangent vec
	tangent_line.points.clear()
	tangent_line.points.append(hit.position)
	tangent_line.points.append(hit.position + tangent_vec)
	# compute reflected vec
	var reflected_vec = tangent_vec * (incident.dot(tangent_vec)) + hit.normal * (-1 * incident.dot(hit.normal))
	#laser_line.points.append(hit.position + reflected_vec.normalized() * cast_length)
	for i in range(1, max_bounces):
		raycastStart = hit.position
		raycastEnd = hit.position + reflected_vec.normalized() * cast_length
		hit = space_state.intersect_ray(raycastStart, raycastEnd)
		laser_line.points.append(hit.position if hit else raycastEnd)
		if not hit:
			return
		incident = raycastEnd - raycastStart
		cross_vec = incident.cross(hit.normal)
		tangent_vec = hit.normal.cross(cross_vec).normalized()
		reflected_vec = tangent_vec * (incident.dot(tangent_vec)) + hit.normal * (-1 * incident.dot(hit.normal))

