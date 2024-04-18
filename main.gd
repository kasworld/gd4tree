extends Node3D

var tree_scene = preload("res://bar_tree/bar_tree.tscn")
var tree2_scene = preload("res://bar_tree_2/bar_tree_2.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)

	make_tree(Vector3(0,0,0),2,2)
	make_tree(Vector3(1.5,0,1.5),2,2)
	make_tree(Vector3(-1.5,0,-1.5),2,2)
	make_tree(Vector3(1.5,0,-1.5),2,2)
	make_tree(Vector3(-1.5,0,1.5),2,2)


func make_tree(p :Vector3, wmax:float, hmax:float)->BarTree2:
	var t = tree2_scene.instantiate()
	add_child(t)
	t.position = p
	var w = randf_range(wmax*0.5,wmax*1.0)
	var h = randf_range(hmax*0.5,hmax*1.0)
	var bw = w * randf_range(0.5 , 2.0)/10
	var bc = randf_range(5,20)
	match randi_range(0,3):
		0:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = floor_img
			t.init_with_material(mat,w,h, bw, h*bc, 0.1, true)
		1:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = leaf_img
			mat.uv1_triplanar = true
			t.init_with_material(mat,w,h, bw, h*bc, 0.1, true)
		_:
			t.init_with_color(random_color(), random_color(), w,h, bw, h*bc, 0.1, true)
	return t

func random_color()->Color:
	return Color(randf(),randf(),randf())

func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*2.5 ,2.5, cos(t)*2.5  )
	$Camera3D.look_at(Vector3.ZERO)
