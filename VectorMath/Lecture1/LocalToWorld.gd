tool
extends Node2D

var object: Node
var point: Node
var label: Node
var label_text: String = 'point global coords: %s\n' +\
	'word_to_local: %s\n' +\
	'local_to_world: %s\n'

func _init():
	if not Engine.editor_hint:
		return
	set_process(true)
	object = get_node("Object")
	point = get_node("Point")
	label = get_node("Label")

func _ready():
	object = get_node("Object")
	point = get_node("Point")
	label = get_node("Label")

func _draw():
	draw_line(object.position, object.position + object.transform.y * 100, Color.green)
	draw_line(object.position, object.position + object.transform.x * 100, Color.red)
	draw_circle(point.position, 20.0, Color.pink)

func _process(delta):
	var world_to_local = world_to_local(point.position)
	var local_to_world = local_to_world(world_to_local) 
	label.text = label_text % [point.position, world_to_local, local_to_world]
	update()

func world_to_local(world: Vector2) -> Vector2:
	var det = 1.0 / (object.transform.x[0] * object.transform.y[1] - object.transform.x[1] * object.transform.y[0])
	var displaced_point = world - object.position
	var local_x = det * Vector2(object.transform.y[1], -1*object.transform.y[0]).dot(displaced_point)
	var local_y = det * Vector2(-1*object.transform.x[1], object.transform.x[0]).dot(displaced_point)
	return Vector2(local_x, local_y)

func local_to_world(local: Vector2) -> Vector2:
	var world_x = Vector2(object.transform.x[0], object.transform.y[0]).dot(local)
	var world_y = Vector2(object.transform.x[1], object.transform.y[1]).dot(local)
	var world_pos = Vector2(world_x, world_y) + object.position
	return world_pos
