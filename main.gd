extends Node3D

var tree_scene = preload("res://tree_cylinder/tree_cylinder.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")

var color_tree :Node3D
var mat_tree :Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)

	color_tree = tree_scene.instantiate()
	color_tree.init_with_color(Color.RED, Color.BLUE,true)
	add_child(color_tree)
	color_tree.position = Vector3(1,0,1)

	var mat = StandardMaterial3D.new()
	mat.albedo_texture = floor_img
	mat_tree = tree_scene.instantiate()
	mat_tree.init_with_material(mat)
	add_child(mat_tree)
	mat_tree.position = Vector3(-1,0,-1)
	mat_tree.set_rotate_direction(-1)

func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*2 ,2, cos(t)*2  )
	$Camera3D.look_at(Vector3.ZERO)

	color_tree.bar_rotate_y(delta)
	mat_tree.bar_rotate_y(delta)
