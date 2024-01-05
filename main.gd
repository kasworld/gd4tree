extends Node3D

var tree_scene = preload("res://bar_tree/bar_tree.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

var tree_list :Array

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)

	var tr :BarTree
	tr = tree_scene.instantiate()
	tr.init_with_color(Color.RED, Color.BLUE,true)
	add_child(tr)
	tr.position = Vector3(1.5,0,1.5)
	tr.set_rotate_direction(0.3)
	tree_list.append(tr)

	tr = tree_scene.instantiate()
	tr.init_with_color(Color.BLUE, Color.RED,false)
	add_child(tr)
	tr.position = Vector3(-1.5,0,-1.5)
	tr.set_rotate_direction(0.6)
	tree_list.append(tr)

	var mat = StandardMaterial3D.new()
	mat.albedo_texture = floor_img
	#mat.uv1_triplanar = true
	tr = tree_scene.instantiate()
	tr.init_with_material(mat)
	add_child(tr)
	tr.position = Vector3(1.5,0,-1.5)
	tr.set_rotate_direction(-0.3)
	tree_list.append(tr)

	mat = StandardMaterial3D.new()
	mat.albedo_texture = leaf_img
	mat.uv1_triplanar = true
	tr = tree_scene.instantiate()
	tr.init_with_material(mat)
	add_child(tr)
	tr.position = Vector3(-1.5,0,1.5)
	tr.set_rotate_direction(-0.6)
	tree_list.append(tr)


func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*2.5 ,2.5, cos(t)*2.5  )
	$Camera3D.look_at(Vector3.ZERO)

	for n in tree_list:
		n.bar_rotate_y(delta)
