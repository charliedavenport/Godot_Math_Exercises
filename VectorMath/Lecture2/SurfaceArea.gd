tool
extends Spatial

var sphere_mesh: MeshInstance
var cube_mesh: MeshInstance
var capsule_mesh: MeshInstance

func _init():
	if not Engine.editor_hint:
		return
	sphere_mesh = get_node("SphereMesh")
	cube_mesh = get_node("CubeMesh")
	capsule_mesh = get_node("CapsuleMesh")
	var cube_sfc_area = sfc_area(cube_mesh)
	print('Cube surface area = %s' % cube_sfc_area)			# 2 x 2 x 6 = 24 
	var sphere_sfc_area = sfc_area(sphere_mesh)
	print('Sphere surface area = %s' % sphere_sfc_area) 	# 4 pi r^2 = 12.566...
	var capsule_sfc_area = sfc_area(capsule_mesh)
	print('Capsule surface area = %s' % capsule_sfc_area)	# 12.566 + 2 pi = 18.849...
	print('\n')

func sfc_area(mi: MeshInstance) -> float:
	# boilerplate stuff
	var arr_mesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mi.mesh.get_mesh_arrays())
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(arr_mesh, 0)
#	print('faces: %s' % mdt.get_face_count())
#	print('edges: %s' % mdt.get_edge_count())
#	print('verts: %s' % mdt.get_vertex_count())
	# calc
	var sfc_area := 0.0
	for i in range(mdt.get_face_count()):
		#print('%s, %s, %s' % [mdt.get_face_vertex(i,0), mdt.get_face_vertex(i,1), mdt.get_face_vertex(i,2)])
		var face_ind = [mdt.get_face_vertex(i,0), mdt.get_face_vertex(i,1), mdt.get_face_vertex(i,2)]
		var vert_a = mdt.get_vertex(face_ind[0])
		var vert_b = mdt.get_vertex(face_ind[1])
		var vert_c = mdt.get_vertex(face_ind[2])
		# clockwise winding order
		var a_to_b = vert_b - vert_a
		var a_to_c = vert_c - vert_a
		# cross product = area of parallelogram 
		var tri_sfc_area = a_to_b.cross(a_to_c).length() / 2.0
		sfc_area += tri_sfc_area
	return sfc_area
