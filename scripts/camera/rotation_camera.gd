class_name RotationCamera

extends Spatial

const RADIUS := 50.0

export var rotation_speed := 0.5

var _current_angle := 0.0

onready var _camera := get_node("%Camera") as Camera


func _process(delta: float) -> void:
	_current_angle = fmod(_current_angle + delta * rotation_speed, 180)
	_camera.transform.origin = Vector3(
		RADIUS * cos(_current_angle), 15.0, RADIUS * sin(_current_angle)
	)
	_camera.look_at(Vector3.ZERO, Vector3.UP)
