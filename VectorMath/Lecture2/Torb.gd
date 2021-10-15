tool
extends Spatial

export var max_bounces: int = 3
export var cast_length: float = 10.0

# used by TorbTurret.gd
var is_raycast_hit: bool
var hit_pos: Vector3
var hit_basis_y: Vector3
var hit_basis_z: Vector3
var hit_basis_x: Vector3

var cam_pivot: Spatial
var view_line: Node
var normal_line: Node
var tangent_line: Node
var turret: Node

func _init():
	if not Engine.editor_hint:
		return
	view_line = get_node("ViewLine")
	normal_line = get_node("NormalLine")
	tangent_line = get_node("TangentLine")
	cam_pivot = get_node("CameraPivot")
	#turret = get_node("Turret")		# TODO: how to cleanly access turret if it's a separate scene
	set_process(true)
	set_physics_process(true)

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	shoot_cam_pivot(space_state)

func shoot_cam_pivot(space_state):
	# initial raycast
	view_line.points.clear()
	view_line.points.append(cam_pivot.global_transform.origin)
	var raycastStart = cam_pivot.global_transform.origin
	var raycastEnd = cam_pivot.global_transform.origin + cam_pivot.global_transform.basis.z.normalized() * cast_length
	var hit = space_state.intersect_ray(raycastStart, raycastEnd)
	view_line.points.append(hit.position if hit else raycastEnd)
	normal_line.points.clear()
	if not hit:
		normal_line.visible = false
		tangent_line.visible = false
		is_raycast_hit = false
		return
	is_raycast_hit = true
	# draw normal vector on sphere
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
	# populate variables used by TorbTurret.gd
	hit_pos = hit.position
	hit_basis_y = hit.normal
	hit_basis_z = tangent_vec.normalized()
	hit_basis_x = cross_vec.normalized()
	


