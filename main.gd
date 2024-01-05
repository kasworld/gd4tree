extends Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	$TreeCylinder.init()

func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /10
	$Camera3D.position = Vector3(sin(t)*2 ,2, cos(t)*2  )
	$Camera3D.look_at(Vector3.ZERO)

