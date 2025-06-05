extends Node3D

var tree_scene = preload("res://bar_tree/bar_tree.tscn")
var tree2_scene = preload("res://bar_tree_2/bar_tree_2.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)

	var n := 4
	var rd := 2*PI/n
	var r := 2.0
	for i in n:
		var pos = Vector3(sin(rd*i)*r, 0 , cos(rd*i)*r)
		make_tree(i, pos, 2,2)

func make_tree(btt:int, p :Vector3, wmax:float, hmax:float)->BarTree2:
	var t = tree2_scene.instantiate()
	add_child(t)
	t.position = p
	var w = randf_range(wmax*0.5,wmax*1.0)
	var h = randf_range(hmax*0.5,hmax*1.0)
	var bw = w * randf_range(0.5 , 2.0)/10
	var bc = randf_range(5,20)
	match btt:
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

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
}

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()
