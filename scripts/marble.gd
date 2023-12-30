class_name Marble

extends RigidBody3D

enum State { PAUSED, ROLL, EXPLODED, FINISH, OOB }

const CollisionLayers := preload("res://scripts/constants/collision_layers.gd")

var Group = load("res://scripts/constants/groups.gd")

var _state = State.PAUSED
var _checkpoint_count := 0

@onready var _name := get_node(^"%Name") as Label3D
@onready var _bomb_sound = get_node(^"%BombSound")
@onready var _score = get_node(^"%Score")
@onready var _ball_mesh := get_node(^"%Ball")


func _ready() -> void:
	add_to_group(Group.MARBLES)

	randomize()

	# Set material color
	var color = Color(randf(), randf(), randf())
	var x_ray_material: StandardMaterial3D = (
		_ball_mesh.get_active_material(0)
	)
	x_ray_material.set_albedo(color)
	var toon_material: StandardMaterial3D = x_ray_material.get_next_pass()
	toon_material.set_albedo(color)
#		toon_material.set_shader_parameter(&"albedo", color)
	x_ray_material.set_next_pass(toon_material)
	_ball_mesh.set_surface_override_material(0, x_ray_material)

	# Set collision mask
	var collision_enabled = SettingsManager.get_value(&"marbles", &"collision_enabled") as bool
	if collision_enabled:
		collision_mask = 1 << CollisionLayers.PROPS | 1 << CollisionLayers.MARBLES
	else:
		collision_mask = 1 << CollisionLayers.PROPS

	pause()


func _unhandled_input(event):
	if OS.is_debug_build():
		if event is InputEventKey:
			if event.pressed:
				match event.keycode:
					KEY_F1:
						if _score.visible:
							_score.hide()
						else:
							_score.show()


func set_marble_name(marble_name: StringName) -> void:
	_name.set_text(marble_name)


func get_marble_name() -> StringName:
	return _name.get_text()


func incr_checkpoint_count() -> void:
	_checkpoint_count += 1
	if OS.is_debug_build():
		_score.set_text(str(_checkpoint_count))


func get_checkpoint_count() -> int:
	return _checkpoint_count


func in_race() -> bool:
	return _state == State.ROLL


func has_finish() -> bool:
	return _state == State.FINISH


func has_explode() -> bool:
	return _state == State.EXPLODED


func has_oob() -> bool:
	return _state == State.OOB


func _process(_delta: float) -> void:
	var offset := global_transform.origin + Vector3(0, 0.5, 0)
	_name.global_transform.origin = offset
	_score.global_transform.origin = offset + Vector3(-0.4, -0.2, 0)

	if global_transform.origin.y < -10000:
		out_of_bound()


func reset() -> void:
	_start()
	_checkpoint_count = 0


func roll() -> void:
	_state = State.ROLL
	reset()


func finish() -> void:
	_state = State.FINISH
	_stop()


func explode() -> void:
	_state = State.EXPLODED
	_bomb_sound.play()
	_stop()


func out_of_bound() -> void:
	_state = State.OOB
	_stop()


func pause() -> void:
	_state = State.PAUSED
	_stop()


func _start() -> void:
	show()
	set_process(true)
	set_physics_process(true)
	set_sleeping(false)
	set_linear_velocity(Vector3.ZERO)
	collision_layer = 1 << CollisionLayers.MARBLES


func _stop() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	set_sleeping(true)
	set_linear_velocity(Vector3.ZERO)
	collision_layer = 0
