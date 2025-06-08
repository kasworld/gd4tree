extends Node3D

var tree2_scene = preload("res://bar_tree_2/bar_tree_2.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

var field_size := Vector2(10,10)

func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	var 패널넖이 = vp_size.x/10
	$오른쪽패널.size = Vector2(패널넖이, vp_size.y)
	$오른쪽패널.position = Vector2(vp_size.x - 패널넖이, 0)

	$Floor.mesh.size = field_size
	$OmniLight3D.position.y = field_size.length()
	$DirectionalLight3D.position = Vector3(field_size.x/2, field_size.length(), field_size.y/2 )
	$DirectionalLight3D.look_at(Vector3.ZERO)
	var n := 64
	for i in n:
		make_tree(i,n)

func calc_posi_by_i(i :int, n:int) -> Vector2i:
	var sqrtn :int = sqrt(n)
	var rtn = Vector2i(i / sqrtn, i % sqrtn)
	#print(rtn)
	return rtn

func calc_posf_by_i(i :int, n:int) -> Vector2:
	var sqrtni :int = sqrt(n)
	var posi := calc_posi_by_i(i,n)
	var x = posi.x / float(sqrtni-1) - 0.5
	var y = posi.y / float(sqrtni-1) - 0.5
	return Vector2(x,y)

func make_tree(i :int, n:int)->BarTree2:
	var posf := calc_posf_by_i(i,n)
	var pos = Vector3( posf.x*field_size.x*0.9, 0, posf.y*field_size.y*0.9 )
	var sqrtn := sqrt(n)
	var wmax := field_size.x /sqrtn
	var hmax := field_size.x /sqrtn
	var tree_width := wmax/3
	var tree_height := hmax
	var bar_width = tree_width * randf_range(0.5 , 2.0)/10
	var bar_count := randf_range(5,200)
	var bar_rotation := 0.1
	var bar_rotation_begin := randf_range(0,2*PI)
	var type_make = [0,1,2,2].pick_random()

	var make_flag := randi_range(1,7)
	var t :BarTree2	
	# add left side 
	if make_flag & (1<<0) != 0:
		t = tree2_scene.instantiate().init_common_params(tree_width, tree_height, bar_width, bar_count, bar_rotation, bar_rotation_begin, 2.0, true)
		$BarTreeContainer.add_child(t)
		t.position = pos
		type_make = [0,1,2,2].pick_random()
		init_tree_material(type_make,t)

	# add right side 
	if make_flag & (1<<1) != 0:
		t = tree2_scene.instantiate().init_common_params(tree_width, tree_height, bar_width, bar_count, bar_rotation, bar_rotation_begin , -2.0, true)
		$BarTreeContainer.add_child(t)
		t.position = pos
		type_make = [0,1,2,2].pick_random()
		init_tree_material(type_make,t)

	# add center 
	if make_flag & (1<<2) != 0:
		if make_flag == (1<<2):
			tree_width *= 3
		else:
			tree_width *= 0.9
		t = tree2_scene.instantiate().init_common_params(tree_width, tree_height, bar_width, bar_count, bar_rotation, bar_rotation_begin, 0, true)
		$BarTreeContainer.add_child(t)
		t.position = pos
		type_make = [0,1,2,2].pick_random()
		init_tree_material(type_make,t)

	return t

func init_tree_material(i :int, t:BarTree2):
	match i :
		0:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = floor_img
			t.init_with_material(mat)
		1:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = leaf_img
			mat.uv1_triplanar = true
			t.init_with_material(mat)
		2:
			t.init_with_color(random_color(), random_color())
		_:
			assert(false)

func random_color()->Color:
	return Color(randf(),randf(),randf())

func _process(_delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*field_size.length()/3 ,field_size.length()/3, cos(t)*field_size.length()/3  )
	$Camera3D.look_at(Vector3.ZERO)

var key2fn = {
	KEY_ESCAPE: _on_button_esc_pressed,
	KEY_UP: _on_막대기수늘리기_pressed,
	KEY_DOWN: _on_막대기수줄이기_pressed,
	KEY_RIGHT: _on_오른쪽으로돌리기_pressed,
	KEY_LEFT: _on_왼쪽으로돌리기_pressed,
	KEY_C: _on_색깔바꾸기_pressed,
	KEY_SPACE: _on_멈추기_pressed,
	KEY_ENTER: _on_재정렬하기_pressed,
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

func _on_막대기수늘리기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bt.set_visible_bar_count(bt.bar_count +1)

func _on_막대기수줄이기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bt.set_visible_bar_count(bt.bar_count -1)

func _on_오른쪽으로돌리기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bt.bar_rotation = abs(bt.bar_rotation)

func _on_왼쪽으로돌리기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bt.bar_rotation = -abs(bt.bar_rotation)

func _on_멈추기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bt.auto_rotate_bar = not bt.auto_rotate_bar

func _on_재정렬하기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bt.update_bar_transform()

func _on_색깔바꾸기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		if bt.use_color:
			bt.set_bar_color(random_color(), random_color())
