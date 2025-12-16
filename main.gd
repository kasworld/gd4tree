extends Node3D

var tree2_scene = preload("res://bar_tree_2/bar_tree_2.tscn")
var brown_img = preload("res://image/Dark-brown-fine-wood-texture.jpg")
var floor_img = preload("res://image/floorwood.jpg")
var leaf_img = preload("res://image/leaf.png")

const WorldSize := Vector3(30,20,30)

func ui_panel_init() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var 짧은길이 :float = min(vp_size.x, vp_size.y)
	var panel_size := Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$"왼쪽패널".size = panel_size
	$"왼쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.size = panel_size
	$"오른쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)
func on_viewport_size_changed():
	ui_panel_init()

func label_demo() -> void:
	if $"왼쪽패널/LabelPerformance".visible:
		$"왼쪽패널/LabelPerformance".text = """%d FPS (%.2f mspf)
Currently rendering: occlusion culling:%s
%d objects
%dK primitive indices
%d draw calls""" % [
		Engine.get_frames_per_second(),1000.0 / Engine.get_frames_per_second(),
		get_tree().root.use_occlusion_culling,
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME),
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_PRIMITIVES_IN_FRAME) * 0.001,
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME),
		]
	if $"왼쪽패널/LabelInfo".visible:
		$"왼쪽패널/LabelInfo".text = "%s" % [ MovingCameraLight.GetCurrentCamera() ]


func _ready() -> void:
	get_viewport().size_changed.connect(on_viewport_size_changed)
	ui_panel_init()

	$Floor.mesh.size = Vector2(WorldSize.z, WorldSize.x)
	$OmniLight3D.position = Vector3(0,0,WorldSize.length())
	$OmniLight3D.omni_range = WorldSize.length()*2
	$FixedCameraLight.set_center_pos_far(Vector3.ZERO, 	Vector3(0, 0, WorldSize.z*2), WorldSize.length()*2)
	$MovingCameraLightHober.set_center_pos_far( Vector3.ZERO, Vector3(0, 0, WorldSize.z), WorldSize.length()*2)
	$MovingCameraLightAround.set_center_pos_far( Vector3.ZERO, Vector3(0, 0, WorldSize.z), WorldSize.length()*2)
	$AxisArrow3D.set_size(WorldSize.length()/10)

	var xn = 8
	var yn = 8
	for i in xn*yn:
		var r = min( WorldSize.x / xn, WorldSize.z / yn )
		var adjust = Vector2( 1.0- r/WorldSize.x , 1.0- r/WorldSize.z )
		var pos = calc_posf_by_i(i, xn, yn)
		make_tree(r,r,Vector3(pos.y*WorldSize.z*adjust.y , 0, pos.x*WorldSize.x*adjust.x))

func calc_posi_by_i(i :int, xn:int) -> Vector2i:
	return Vector2i(i % xn, i / xn)

func calc_posf_by_i(i :int, xn :int, yn :int) -> Vector2:
	var posi := Vector2i(i % xn, i / xn)
	var x = posi.x / float(xn-1) - 0.5
	var y = posi.y / float(yn-1) - 0.5
	return Vector2(x,y)

func make_tree(wmax :float, hmax :float, pos :Vector3)->BarTree2:
	var tree_width := wmax/3
	var tree_height := hmax
	var bar_width :float = tree_width * randf_range(0.5 , 2.0)/10
	var bar_count := randi_range(5,200)
	#var bar_rotation := 0.1
	var type_make :int = [0,1,2,2].pick_random()
	var tree_size := Vector3(tree_width,tree_height,bar_width)

	var make_flag := randi_range(1,7)
	var t :BarTree2
	# add left side
	if make_flag & (1<<0) != 0:
		t = tree2_scene.instantiate()
		$BarTreeContainer.add_child(t)
		t.position = pos
		type_make = [0,1,2,2].pick_random()
		init_tree_material(type_make, t, bar_count)
		t.init_bartree_transform(tree_size, 2.0)

	# add right side
	if make_flag & (1<<1) != 0:
		t = tree2_scene.instantiate()
		$BarTreeContainer.add_child(t)
		t.position = pos
		type_make = [0,1,2,2].pick_random()
		init_tree_material(type_make, t, bar_count)
		t.init_bartree_transform(tree_size, -2.0)

	# add center
	if make_flag & (1<<2) != 0:
		if make_flag == (1<<2):
			tree_width *= 3
		else:
			tree_width *= 0.9
		tree_size = Vector3(tree_width,tree_height,bar_width)
		t = tree2_scene.instantiate()
		$BarTreeContainer.add_child(t)
		t.position = pos
		type_make = [0,1,2,2].pick_random()
		init_tree_material(type_make, t, bar_count)
		t.init_bartree_transform(tree_size, 0)

	return t

func init_tree_material(i :int, t:BarTree2, bar_count :int):
	match i :
		0:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = floor_img
			t.init_bartree_with_material(mat, bar_count)
		1:
			var mat = StandardMaterial3D.new()
			mat.albedo_texture = leaf_img
			mat.uv1_triplanar = true
			t.init_bartree_with_material(mat, bar_count)
		2:
			t.init_bartree_with_color(random_color(), random_color(), bar_count)
		_:
			assert(false)

func random_color()->Color:
	return Color(randf(),randf(),randf())

var bar_rot := 0.1
func _process(_delta: float) -> void:
	label_demo()

	var t := Time.get_unix_time_from_system() /2.3
	if $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(t, Vector3.ZERO, (WorldSize.x+WorldSize.y)/2, WorldSize.length()*0.6 )
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(t, Vector3.ZERO, (WorldSize.x+WorldSize.y)/2, WorldSize.length()*0.6 )
	for n in $BarTreeContainer.get_children():
		n.rotate_tree_bar_y(bar_rot)

func _on_카메라변경_pressed() -> void:
	MovingCameraLight.NextCamera()

func _on_button_fov_up_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_dec()

var key2fn = {
	KEY_ESCAPE: _on_button_esc_pressed,
	KEY_ENTER:_on_카메라변경_pressed,
	KEY_PAGEUP:_on_button_fov_up_pressed,
	KEY_PAGEDOWN:_on_button_fov_down_pressed,

	#KEY_UP: _on_막대기수늘리기_pressed,
	#KEY_DOWN: _on_막대기수줄이기_pressed,
	KEY_RIGHT: _on_오른쪽으로돌리기_pressed,
	KEY_LEFT: _on_왼쪽으로돌리기_pressed,
	KEY_C: _on_색깔바꾸기_pressed,
	KEY_SPACE: _on_멈추기_pressed,
	#KEY_ENTER: _on_재정렬하기_pressed,
}

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
		if $FixedCameraLight.is_current_camera():
			var fi = FlyNode3D.Key2Info.get(event.keycode)
			if fi != null:
				FlyNode3D.fly_node3d($FixedCameraLight, fi)
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()

#func _on_막대기수늘리기_pressed() -> void:
	#for bt in $BarTreeContainer.get_children():
		#bt.set_visible_bar_count(bt.bar_count +1)
#
#func _on_막대기수줄이기_pressed() -> void:
	#for bt in $BarTreeContainer.get_children():
		#bt.set_visible_bar_count(bt.bar_count -1)
#
func _on_오른쪽으로돌리기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bar_rot = -0.1

func _on_왼쪽으로돌리기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bar_rot = 0.1

func _on_멈추기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		bar_rot = 0.0

#func _on_재정렬하기_pressed() -> void:
	#for bt in $BarTreeContainer.get_children():
		#bt.update_bar_transform()

func _on_색깔바꾸기_pressed() -> void:
	for bt in $BarTreeContainer.get_children():
		if bt.color_used():
			bt.set_gradient_color(random_color(), random_color())
