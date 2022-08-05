class_name Marble

extends RigidBody

const AVG_AMOUNT := 10

var Group = load("res://scripts/constants/groups.gd")

var _ground_normal := Vector3.UP
var _avg_ground_normal := Vector3.UP
var _avg_pos := Vector3.ZERO
var _last_contact_time := 0.0

onready var _name := get_node("%Name") as Label3D


func _ready() -> void:
	add_to_group(Group.MARBLES)


func set_name(name: String) -> void:
	_name.set_text(name)


func get_name() -> String:
	return _name.get_text()


func get_avg_ground_normal() -> Vector3:
	return _avg_ground_normal


func get_avg_position() -> Vector3:
	return _avg_pos


func _process(_delta: float) -> void:
	if translation.y < -100:
		print("Marble is too low, freeing")
		queue_free()
	var offset = global_transform.origin + Vector3(0, 0.5, 0)
	_name.global_transform.origin = offset


func _integrate_forces(state: PhysicsDirectBodyState) -> void:
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
