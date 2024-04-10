extends Node3D

var tree_scene = preload("res://bar_tree/bar_tree.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)

	var t :BarTree
	t = new_tree_at(Vector3(0,0,0))
	t.init_with_color(Color.BLACK, Color.YELLOW, true,1,1, 10,200, 10.0,1.0/60.0)

	t = new_tree_at(Vector3(1.5,0,1.5))
	t.init_with_color(Color.RED, Color.BLUE,true,2,1.5, 3,20, 3.0,1.0/60.0)

	t = new_tree_at(Vector3(-1.5,0,-1.5))
	t.init_with_color(Color.BLUE, Color.RED,false,2,2, 3,200, 6.0,1.0/60.0)

	var mat = StandardMaterial3D.new()
	mat.albedo_texture = floor_img
	#mat.uv1_triplanar = true
	t = new_tree_at(Vector3(1.5,0,-1.5))
	t.init_with_material(mat,3,1.6, 3,100, -3.0,1.0/60.0)

	mat = StandardMaterial3D.new()
	mat.albedo_texture = leaf_img
	mat.uv1_triplanar = true
	t = new_tree_at(Vector3(-1.5,0,1.5))
	t.init_with_material(mat,1.5,1.3, 3,70, -6.0,1.0/60.0)

func new_tree_at(p :Vector3)->BarTree:
	var t = tree_scene.instantiate()
	add_child(t)
	t.position = p
	return t

func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*2.5 ,2.5, cos(t)*2.5  )
	$Camera3D.look_at(Vector3.ZERO)
