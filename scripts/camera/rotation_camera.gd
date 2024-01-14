class_name RotationCamera

extends Node3D

@export var rotation_speed := 0.25
@export var target := Vector3.ZERO
@export var y_pos := 5.0
@export var move_y_pos := true
@export var distance_to_target := 50.0

var _current_angle := 0.0

@onready var _camera := get_node(^"%Camera") as Camera3D


func _process(delta: float) -> void:
	_current_angle = fmod(_current_angle + delta * rotation_speed, 180)

	var center = to_local(target)
	var x := distance_to_target * cos(_current_angle)
	var y := y_pos
	var z := distance_to_target * sin(_current_angle)

	if move_y_pos:
		y = sin(_current_angle) * 2.0

	_camera.position = Vector3(x, y, z) + center
	_camera.look_at(center, Vector3.UP)
