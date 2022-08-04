extends Spatial

const ORBIT_SENSITIVITY = 0.01
const PAN_SENSITIVITY = 0.002
const ZOOM_SPEED = 0.1

var _yaw = 0.0
var _pitch = 0.0
var _distance = 5.0

onready var _camera = get_node("Camera")


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
			if Input.is_key_pressed(KEY_SHIFT):
				var rel = event.relative * PAN_SENSITIVITY * _distance
				var trans = _camera.global_transform
				var right = trans.basis.x
				var up = trans.basis.y
				translation += -right * rel.x + up * rel.y

			else:
				var rel = event.relative * ORBIT_SENSITIVITY
				_yaw += rel.x
				_pitch += rel.y
				update_camera_transform()

	elif event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_WHEEL_DOWN:
				_distance *= (1.0 + ZOOM_SPEED)
				update_camera_transform()

			elif event.button_index == BUTTON_WHEEL_UP:
				_distance /= (1.0 + ZOOM_SPEED)
				update_camera_transform()


func update_camera_transform():
	var pos = _distance * Vector3(cos(_yaw) * cos(_pitch), sin(_pitch), cos(_pitch) * sin(_yaw))

	_camera.look_at_from_position(translation + pos, translation, Vector3.UP)
