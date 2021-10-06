tool
extends Node2D

func _ready():
	set_process(true)

func _init():
	set_process(true)

func _draw():
	var vec = get_global_mouse_position().normalized() * 200
	#print(mouse_pos)
	draw_line(Vector2.ZERO, vec, Color.white)

func _process(delta):
	update()
