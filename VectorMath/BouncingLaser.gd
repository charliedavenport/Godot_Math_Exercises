tool
extends Spatial

export var max_bounces: int = 3
export var cast_length: float = 10.0

var laser: Spatial
var laser_line: Node
var normal_line: Node

func _init():
	if not Engine.editor_hint:
		return
	set_process(true)
	set_physics_process(true)
	laser = get_node("Laser")
	laser_line = get_node("LaserLine")
	normal_line = get_node("SphereNormalLine")

func _ready():
	laser = get_node("Laser")
	laser_line = get_node("LaserLine")
	normal_line = get_node("SphereNormalLine")

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	shoot_laser(space_state)

func shoot_laser(space_state):
	laser_line.points.clear()
	laser_line.points.append(laser.transform.origin)
	var raycastStart = laser.transform.origin
	var raycastEnd = laser.transform.origin + laser.transform.basis.z.normalized() * cast_length
	var hit = space_state.intersect_ray(raycastStart, raycastEnd)
	laser_line.points.append(hit.position if hit else raycastEnd)
	normal_line.points.clear()
	if not hit:
		normal_line.visible = false
		return
	normal_line.visible = true
	normal_line.points.append(hit.position)
	var normal_to = hit.position + hit.normal
	normal_line.points.append(normal_to)
	for i in range(1, max_bounces):
		raycastStart = hit.position
		

