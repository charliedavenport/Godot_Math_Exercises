tool
extends Spatial

export var max_bounces: int = 3
export var cast_length: float = 10.0

var cam_pivot: Spatial
var view_line: Node
var normal_line: Node
var tangent_line: Node

func _init():
	if not Engine.editor_hint:
		return
	set_process(true)
	set_physics_process(true)
	view_line = get_node("ViewLine")
	normal_line = get_node("NormalLine")
	tangent_line = get_node("TangentLine")

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	shoot_cam_pivot(space_state)

func shoot_cam_pivot(space_state):
	# initial raycast
	view_line.points.clear()
	view_line.points.append(cam_pivot.transform.origin)
	var raycastStart = cam_pivot.transform.origin
	var raycastEnd = cam_pivot.transform.origin + cam_pivot.transform.basis.z.normalized() * cast_length
	var hit = space_state.intersect_ray(raycastStart, raycastEnd)
	view_line.points.append(hit.position if hit else raycastEnd)
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



