tool
extends Spatial

var torb: Spatial 
var turret: Spatial

func _init():
	if not Engine.editor_hint:
		return
	torb = get_node("Torb")
	turret = get_node("Turret")
	set_process(true)

func _process(delta):
	if torb.is_raycast_hit:
		turret.global_transform.origin = torb.hit_pos
		#turret.look_at(torb.global_transform.origin + torb.hit_tangent, torb.hit_normal)
		turret.transform.basis.y = torb.hit_basis_y
		turret.transform.basis.z = torb.hit_basis_z
		turret.transform.basis.x = torb.hit_basis_x
	else:
		turret.global_transform.origin = Vector3(0.0, 3.0, 0.0)
