class_name SpectatorCamera

extends Spatial

export var speed := 10.0

onready var _camera := get_node("%Camera") as Camera


func _physics_process(delta: float) -> void:
	var forward = -_camera.transform.basis.z
	var right = _camera.transform.basis.x
	var up = Vector3.UP

	var dir = Vector3.ZERO

	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_A):
		dir -= right

	elif Input.is_key_pressed(KEY_D):
		dir += right

	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_W):
		dir += forward

	elif Input.is_key_pressed(KEY_S):
		dir -= forward

	if Input.is_key_pressed(KEY_SHIFT):
		dir -= up

	elif Input.is_key_pressed(KEY_SPACE):
		dir += up

	var dir_len = dir.length()
	if dir_len > 0.01:
		dir /= dir_len
		translate(dir * (speed * delta))
