extends Node3D
class_name BarTree

var tree_height :float = 1.6
var tree_width :float = 3.0
var tree_rotation_count :float = 3.0
var bar_count :int = 100

var tree_rotation_direction :float = 1.0
var bar_height :float = tree_height/bar_count
var bar_list :Array

func set_params(h :float, w:float, rot_count :float, rot_dir :float, b_count:int)->void:
	tree_height = h
	tree_width = w
	tree_rotation_count = rot_count
	tree_rotation_direction = rot_dir
	bar_count = b_count
	bar_height = tree_height/bar_count
	for sp in bar_list:
		remove_child(sp)
	bar_list.clear()

func set_rotate_direction(dir :float)->void:
	tree_rotation_direction = dir

func init_with_color(co1 :Color, co2:Color, emission :bool)->void:
	for i in bar_count:
		var rate = float(i)/bar_count
		var bar_color = co1.lerp(co2,rate)
		var mat = MatCache.get_color_mat(bar_color)
		if emission:
			mat.emission_enabled = true
			mat.emission = bar_color
		var sp = new_mat_inst3d(i,mat)
		bar_list.append(sp)
		add_child(sp)

func init_with_material(mat :Material)->void:
	for i in bar_count:
		var sp = new_mat_inst3d(i,mat)
		bar_list.append(sp)
		add_child(sp)

func new_mat_inst3d(i :int, mat :Material)->MeshInstance3D:
	var pos_rev = float(bar_count-i)
	var pos_rev_rate = pos_rev / float(bar_count)
	var y = float(i) * bar_height
	var l = pos_rev / bar_count * tree_width
	var bar_width = bar_height* tree_width*tree_rotation_count *pos_rev_rate
	var bar_size = Vector3(bar_width, bar_height, l)
	var mesh = BoxMesh.new()
	mesh.size = bar_size
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	sp.position.y = y
	return sp

func reset_bar_rotation()->void:
	for sp in bar_list:
		sp.rotation = Vector3.ZERO

func set_bar_rotate_y(delta:float)->void:
	for i in bar_list.size():
		bar_list[i].rotation.y =  delta * (tree_rotation_direction * float(i)*tree_rotation_count*PI/bar_count)

func bar_rotate_y(delta:float)->void:
	for i in bar_list.size():
		bar_list[i].rotate_y( delta * (tree_rotation_direction * float(i)*tree_rotation_count*PI/bar_count) )
