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

func make_tree(i :int, n:int)->BarTree2:
	var sqrtn :int = sqrt(n)
	var wmax := field_size.x /sqrtn
	var hmax := field_size.x /sqrtn
	var xi :int = (i / sqrtn) 
	var x = xi / float(sqrtn-1) - 0.5
	var yi :int = (i % sqrtn) 
	var y = yi / float(sqrtn-1) - 0.5
	print(xi," ", yi)
	var pos = Vector3( x*field_size.x*0.9, 0, y*field_size.y*0.9 )
	var t = tree2_scene.instantiate()
	$BarTreeContainer.add_child(t)
	t.position = pos
	var bar_shift_rate = [0.0, 0.5, 1.0, 1.5, 2.0][i%5]
	var tree_width = randf_range(wmax*0.5,wmax*1.0) / (bar_shift_rate+1)
	var tree_height := randf_range(hmax*0.5,hmax*1.0)
	var bar_width = tree_width * randf_range(0.5 , 2.0)/10
	var bar_count := randf_range(5,100)
	var bar_rotation := 0.1
	t.init_common_params(tree_width, tree_height, bar_width, tree_height*bar_count, bar_rotation, randf_range(0,2*PI), bar_shift_rate, true)
	match i % 4:
		0:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = floor_img
			t.init_with_material(mat)
		1:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = leaf_img
			mat.uv1_triplanar = true
			t.init_with_material(mat)
		_:
			t.init_with_color(random_color(), random_color())
	return t

func random_color()->Color:
	return Color(randf(),randf(),randf())

func _process(delta: float) -> void:
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
