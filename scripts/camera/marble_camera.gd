extends Spatial

const AVG_AMOUNT = 16

var _target = null
var _prev_pos = Vector3()
var _prev_up = Vector3(0, 1, 0)

onready var _camera = get_node("Camera")


func set_target(t):
	_target = t
	#_target.hide()
	if _target != null:
		translation = _target.translation + Vector3(0.1, 1, 0.1)
	set_physics_process(_target != null)


func has_target():
	return _target != null and is_instance_valid(_target)


func _physics_process(delta):
	if not has_target():
		_target = null
		print("No target")
		set_physics_process(false)
		return
	#process_avg(delta)
	process_ccd(delta)


func process_ccd(_delta):
	var distance = 4.0
	var target_pos = _target.translation
	var normal = Vector3.UP  #_target.get_avg_ground_normal()
	# var v_offset = Vector3(0, 2, 0)
	look_at(target_pos, normal)
	var forward = -transform.basis.z
	var d = target_pos.distance_to(translation)
	if d > distance:
		translation = target_pos - forward * distance


func process_avg(_delta):
	var pos = _target.translation
	var diff = pos - _prev_pos

#	var state = get_viewport().world.direct_space_state
#	state.intersect_ray(pos, pos

	if diff == Vector3():
		print("Diff is zero")
		return

	translation = _prev_pos
	look_at(pos, _target.get_avg_ground_normal())
	var avg = float(AVG_AMOUNT)
	_prev_pos = (_prev_pos * (avg - 1.0) + pos) / avg
