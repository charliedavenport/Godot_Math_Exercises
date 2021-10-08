tool
extends Node2D

export var radius: float = 200

var color: Color

func _init():
	set_process(true)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var dist = (mouse_pos - self.position).length()
	if dist < radius:
		color = Color.green
	else:
		color = Color.red
	update() # calls _draw()

func _draw():
	#draw_circle(origin, radius, color)
	draw_arc(Vector2.ZERO, radius, 0.0, 2*PI, 100, color)

