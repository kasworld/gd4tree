extends Node3D

class_name BarTree2

var tree_width :float = 3.0
var tree_height :float = 1.6
var bar_width :float = 3.0
var bar_shift_rate := 0.0

func init_common_params(
		tree_width_a: float,
		tree_height_a :float,
		bar_width_a :float,
		bar_shift_rate_a :float,
		) -> BarTree2:
	tree_height = tree_height_a
	tree_width = tree_width_a
	bar_width = bar_width_a
	bar_shift_rate = bar_shift_rate_a
	return self

func init_with_color(color_from :Color, color_to:Color, bar_count :int) -> BarTree2:
	$MultiMeshShape.init_with_color(BoxMesh.new(), Color.WHITE, bar_count)
	init_bar_transform()
	init_bar_color(color_from, color_to)
	return self

func init_with_material(mat :Material, bar_count :int) -> BarTree2:
	$MultiMeshShape.init_with_material(BoxMesh.new(), mat, bar_count)
	init_bar_transform()
	return self

# also reset bar rotation
func init_bar_transform() -> void:
	var count :int = $MultiMeshShape.get_visible_count()
	# Set the transform of the instances.
	var bar_height := tree_height/count
	for i in count:
		var rate := float(i)/count
		var rev_rate := 1 - rate
		var bar_position := Vector3(0, i *bar_height +bar_height/2, tree_width * rev_rate /2 * bar_shift_rate)
		var bar_size := Vector3(bar_width * rev_rate, bar_height, tree_width * rev_rate )
		var t := Transform3D(Basis(), bar_position)
		t = t.scaled_local( bar_size )
		$MultiMeshShape.multimesh.set_instance_transform(i,t )

func init_bar_color(color_from :Color, color_to:Color) -> void:
	var count :int = $MultiMeshShape.get_visible_count()
	for i in count:
		var rate = float(i)/count
		$MultiMeshShape.multimesh.set_instance_color(i,color_from.lerp(color_to,rate))

func set_visible_bar_count(bar_count :int) -> void:
	$MultiMeshShape.set_visible_count(bar_count)
	init_bar_transform()

func rotate_bar_y(bar_rotation :float) -> void:
	var count :int = $MultiMeshShape.get_visible_count()
	for i in count:
		var t :Transform3D = $MultiMeshShape.multimesh.get_instance_transform(i)
		var rate := float(i)/count
		var bar_rot := rate * bar_rotation
		t = t.rotated(Vector3(0,1,0), bar_rot)
		$MultiMeshShape.multimesh.set_instance_transform(i,t )
