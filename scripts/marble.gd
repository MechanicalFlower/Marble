extends RigidBody

const AVG_AMOUNT = 10

var Group = load("res://scripts/constants/groups.gd")

var _ground_normal = Vector3.UP
var _avg_ground_normal = Vector3.UP
var _avg_pos = Vector3()
var _last_contact_time = 0.0


func _ready():
	add_to_group(Group.MARBLES)


func get_avg_ground_normal():
	return _avg_ground_normal


func get_avg_position():
	return _avg_pos


func _process(_delta):
	if translation.y < -10:
		print("Marble is too low, freeing")
		queue_free()


func _integrate_forces(state):
	var now = OS.get_ticks_msec()

	if state.get_contact_count() > 0:
		var hit_pos = Vector3()
		for i in state.get_contact_count():
			hit_pos += state.get_contact_collider_position(i)
		hit_pos /= float(state.get_contact_count())
		var diff = state.transform.origin - hit_pos
		if diff != Vector3():
			_ground_normal = diff.normalized()
		_last_contact_time = now
	else:
		_ground_normal = Vector3.UP

	var a = float(AVG_AMOUNT)
	_avg_ground_normal = (_avg_ground_normal * (a - 1) + _ground_normal) / a

	_avg_pos = (_avg_pos * (a - 1.0) + translation) / a
