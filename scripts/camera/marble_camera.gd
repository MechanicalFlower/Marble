class_name MarbleCamera

extends Spatial

const AVG_AMOUNT := 16

var _target: Spatial = null
var _prev_pos := Vector3.ZERO
var _prev_up := Vector3.UP


func set_target(target: Spatial) -> void:
	_target = target
	if _target != null:
		translation = _target.translation + Vector3(0.1, 1, 0.1)
	set_physics_process(_target != null)


func has_target() -> bool:
	return _target != null and is_instance_valid(_target)


func _physics_process(_delta: float) -> void:
	if not has_target():
		_target = null
		set_physics_process(false)
		return
	process_ccd()


func process_ccd() -> void:
	var distance := 4.0
	var target_pos = _target.translation
	var normal = Vector3.UP
	look_at(target_pos, normal)
	var forward = -transform.basis.z
	var d = target_pos.distance_to(translation)
	if d > distance:
		translation = target_pos - forward * distance
