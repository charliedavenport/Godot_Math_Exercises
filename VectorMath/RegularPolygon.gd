tool
extends Node2D

export(int, 0, 100) var points = 3
export(int, 1, 100) var stride

var scaling_factor = 100.0

func _init():
	if not Engine.editor_hint:
		return
	set_process(true)

func _process(delta):
	update()

func _draw():
	var points_list = []
	# define points and draw them
	for i in range(points):
		var t = float(i)/float(points)
		var angle = t * TAU
		var x = cos(angle)
		var y = sin(angle)
		var point = Vector2(x,y) * scaling_factor
		points_list.append(point)
		draw_circle(point, 2.0, Color.aqua)
	# draw lines between points
	for i in range(points):
		var next_ind = (i + stride) % points
		draw_line(points_list[i], points_list[next_ind], Color.white, 2.0)
	
