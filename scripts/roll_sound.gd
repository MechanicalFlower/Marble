class_name RollSound

extends AudioStreamPlayer3D

const AVG_AMOUNT = 10

var _prev_pos = null
var _speed = 0.0
var _last_hit_time = 0.0
var _last_body_enter_time = 0.0
var _last_body_exit_time = 0.0

onready var _hit_sound = get_node("HitSound")


func _ready() -> void:
	play()


func _physics_process(delta: float) -> void:
	var pos = global_transform.origin

	if _prev_pos == null:
		_prev_pos = pos
		return

	var speed = pos.distance_to(_prev_pos) / delta
	var a = float(AVG_AMOUNT)
	_speed = (_speed * (a - 1.0) + speed) / a
	_prev_pos = pos

	# TODO : dicked around for 10min, needs improvements
	pitch_scale = clamp(_speed * 0.5, 0.1, 10.0)
	var linear_vol = clamp(_speed * 0.5 - 2.0, 0.0, 1.0)
	unit_db = linear2db(linear_vol)


func _on_Marble_body_entered(_body) -> void:
	var now = OS.get_ticks_msec()
	_last_body_enter_time = now
	if now - _last_body_exit_time > 500.0:
		if now - _last_hit_time > 500.0:
			_hit_sound.play()
			_last_hit_time = now


func _on_Marble_body_exited(_body) -> void:
	var now = OS.get_ticks_msec()
	_last_body_exit_time = now
