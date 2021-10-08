tool
extends Node2D

export var threshold: float = 0.5

var player: Node
var target: Node
var target_color: Color
var player_to_mouse: Vector2
var player_to_target: Vector2
var dot_prod: float

func _ready():
	player = get_node("Player")
	target = get_node("Target")

func _init():
	if Engine.editor_hint:
		set_process(true)
		player = get_node("Player")
		target = get_node("Target")

func _process(delta):
	player_to_mouse = get_global_mouse_position() - player.position
	player_to_target = target.position - player.position
	dot_prod = player_to_mouse.normalized().dot(player_to_target.normalized())
	#print(dot_prod)
	target_color = Color.green if dot_prod > threshold else Color.red
	update()

func _draw():
	draw_circle(target.position, 20.0, target_color)
	var vec = (get_global_mouse_position() - player.position).normalized() * 100
	draw_line(player.position, player.position + vec, target_color)
