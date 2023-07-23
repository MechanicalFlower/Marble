class_name MarbleCamera

extends Node3D

const AVG_AMOUNT := 16

var _target: Node3D = null


func set_target(target: Node3D) -> void:
	_target = target
	if _target != null:
		position = _target.position + Vector3(0.1, 1, 0.1)
	set_physics_process(_target != null)


func has_target() -> bool:
	return _target != null and is_instance_valid(_target)


func get_target() -> Node3D:
	return _target


func _physics_process(_delta: float) -> void:
	if not has_target():
		_target = null
		set_physics_process(false)
		return
	process_ccd()


func process_ccd() -> void:
	var distance := 4.0
	var target_pos = _target.position
	var normal = Vector3.UP
	look_at(target_pos, normal)
	var forward = -transform.basis.z
	var d = target_pos.distance_to(position)
	if d > distance:
		position = target_pos - forward * distance
