class_name CinematicCamera

extends Node3D

const AVG_AMOUNT := 16

var _target: Node3D = null
var _prev_pos := Vector3.ZERO
var _prev_up := Vector3.UP
var _curve: Curve3D


func set_curve(curve: Curve3D) -> void:
	_curve = curve


func set_target(target: Node3D) -> void:
	_target = target
	if _target != null:
		position = _target.position + Vector3(0.1, 1, 0.1)
	set_physics_process(_target != null)


func has_target() -> bool:
	return _target != null and is_instance_valid(_target)


func get_target() -> Node3D:
	return _target


func _physics_process(delta: float) -> void:
	if not has_target():
		_target = null
		set_physics_process(false)
		return
	process_ccd(delta)


func process_ccd(delta: float) -> void:
	var target_pos = _target.global_position
	position = lerp(position, _curve.get_closest_point(target_pos), 5 * delta)
	look_at(target_pos, Vector3.UP)
