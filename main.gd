extends Node3D

var tree_scene = preload("res://bar_tree/bar_tree.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

var tree_list :Array

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)

	var tr :BarTree
	tr = new_tree_at(Vector3(0,0,0))
	tr.set_params(1,1, 10,200, 10.0)
	tr.init_with_color(Color.BLACK, Color.YELLOW, true)

	tr = new_tree_at(Vector3(1.5,0,1.5))
	tr.set_params(2,1.5, 3,20, 3.0)
	tr.init_with_color(Color.RED, Color.BLUE,true)

	tr = new_tree_at(Vector3(-1.5,0,-1.5))
	tr.set_params(2,2, 3,200, 6.0)
	tr.init_with_color(Color.BLUE, Color.RED,false)

	var mat = StandardMaterial3D.new()
	mat.albedo_texture = floor_img
	#mat.uv1_triplanar = true
	tr = new_tree_at(Vector3(1.5,0,-1.5))
	tr.set_params(3,1.6, 3,100, -3.0)
	tr.init_with_material(mat)

	mat = StandardMaterial3D.new()
	mat.albedo_texture = leaf_img
	mat.uv1_triplanar = true
	tr = new_tree_at(Vector3(-1.5,0,1.5))
	tr.set_params(1.5,1.3, 3,70, -6.0)
	tr.init_with_material(mat)

func new_tree_at(p :Vector3)->BarTree:
	var tr = tree_scene.instantiate()
	add_child(tr)
	tree_list.append(tr)
	tr.position = p
	return tr

func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*2.5 ,2.5, cos(t)*2.5  )
	$Camera3D.look_at(Vector3.ZERO)

	for n in tree_list:
		n.bar_rotate_y(delta)
