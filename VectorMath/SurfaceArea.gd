tool
extends Spatial

var cubePos: Spatial
var spherePos: Spatial

var mesh_list: Array

func _init():
	if not Engine.editor_hint:
		return
	set_process(true)
	#spawn_meshes()
	#var sfc = calc_surface_area(mesh_list[0])

func spawn_meshes() -> void:
	mesh_list = []
	cubePos = get_node("CubePos")
	spherePos = get_node("SpherePos")
	var cube_mesh = create_mesh_instance('cube')
	cubePos.add_child(cube_mesh)
	cube_mesh.set_owner(self)
	mesh_list.append(cube_mesh)
	
	var sphere_mesh = create_mesh_instance('sphere')
	spherePos.add_child(sphere_mesh)
	sphere_mesh.set_owner(self)
	mesh_list.append(sphere_mesh)

func create_mesh_instance(mesh_type) -> MeshInstance:
	var primitive: PrimitiveMesh
	if mesh_type.to_lower() == 'cube':
		primitive = CubeMesh.new()
	elif mesh_type.to_lower() == 'sphere':
		primitive = SphereMesh.new()
	else:
		print('Unsupported mesh type: %s' % mesh_type)
	var mi = MeshInstance.new()
	mi.mesh = primitive
	return mi

func calc_surface_area(mesh: MeshInstance) -> float:
	var arr_mesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.get_mesh_arrays())
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(arr_mesh, 0)
	return 0.0

