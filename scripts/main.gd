# SPDX-FileCopyrightText: 2023 Florian Vazelle <florian.vazelle@vivaldi.net>
#
# SPDX-License-Identifier: MIT

class_name Main

extends Node

enum State { MODE_START, MODE_PAUSE, MODE_MARBLE }

const RotationCamera := preload("res://scenes/camera/rotation_camera.tscn")
const CinematicCamera := preload("res://scenes/camera/marble_camera.tscn")
const Race := preload("res://scenes/race.tscn")

const TIME_PERIOD := 5  # 500ms

var Group := load("res://scripts/constants/groups.gd")
var NameGenerator := load("res://scripts/utils/name_generator.gd")

var _rotation_camera = null
var _cinematic_camera = null
var _mode: int = State.MODE_START
var _current_marble_index := 0
var _time := 0.0
var _explosion_enabled := false
var _need_new_chunk := false
var _race_has_started := false

# There are limited places to ensure equality among the marbles.
# TODO : remove this limit
var _positions := []

onready var _pause_menu := get_node("%Menu") as Menu
onready var _race := get_node("%Race") as Race
onready var _overlay := get_node("%Overlay") as Overlay
onready var _marble_pool := get_node("%MarblePool") as Spatial
onready var _timer := get_node("%Timer") as Timer
onready var _ranking := get_tree().get_nodes_in_group("Ranking")[0] as Ranking
onready var _explosion := get_node("%Explosion") as Particles
onready var _marbles = _marble_pool.get_children()
onready var _panel_timer := _overlay.get_node("Panel2") as ColorRect
onready var _label_timer = _overlay.get_node("Panel2/CenterContainer3/VBoxContainer/LabelTimer")
onready var _transition := get_node("%Transition/ColorRect") as ColorRect
onready var _countdown := get_node("%Countdown")


func _ready() -> void:
	_countdown.connect("start", self, "_start_race")

	_rotation_camera = RotationCamera.instance()
	_cinematic_camera = CinematicCamera.instance()

	reset_position()

	set_mode(_mode)


func _exit_tree():
	if not _rotation_camera.is_inside_tree():
		_rotation_camera.free()
	if not _cinematic_camera.is_inside_tree():
		_cinematic_camera.free()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_TAB:
					if _mode == State.MODE_MARBLE:
						var visible_marbles := []
						for marble in _marbles:
							if marble.visible:
								visible_marbles.append(marble)

						var marble_count = len(visible_marbles)
						if marble_count != 0:
							if _current_marble_index >= marble_count:
								_current_marble_index = 0
							else:
								_current_marble_index += 1
							_cinematic_camera.set_target(
								visible_marbles[_current_marble_index % marble_count]
							)

						else:
							print("Could not place start marble")

				KEY_ESCAPE:
					if _mode != State.MODE_START and _mode != State.MODE_PAUSE:
						set_mode(State.MODE_PAUSE)

				# Debug command to spawn a new marble
				KEY_T:
					if _mode == State.MODE_MARBLE:
						var marbles = _marble_pool.get_children()

						var all_marble_has_finish = true
						for marble in marbles:
							all_marble_has_finish = marble.has_finish()
							if not all_marble_has_finish:
								break

						if all_marble_has_finish:
							_overlay.reset()
							reset_position()

						var marble = try_place_start_marble()
						if marble != null:
							marble.set_name(NameGenerator.generate())
							_overlay.add_marble_rank(marble)

				# Debug command to generate a new race
				KEY_R:
					if _mode == State.MODE_MARBLE:
						_race.call_deferred("generate_race", !_explosion_enabled)

				KEY_SPACE:
					for marble in _marbles:
						var marble_name = marble.get_name().to_lower()
						if marble_name == "maxime" or marble_name == "max":
							marble.set_linear_velocity(-marble.linear_velocity * 2)
							break


func reset_position() -> void:
	_positions = []
	for i in range(7):
		for j in range(2):
			_positions.append([i, j])


func try_place_start_marble() -> Marble:
	var piece = get_highest_piece()
	if piece == null:
		return null
	if len(_positions) == 0:
		print("There are limited places to ensure equality among the marbles.")
		return null
	randomize()
	var position = _positions.pop_at(randi() % len(_positions))
	var marbles = _marble_pool.get_children()

	var new_marble = null
	for marble in marbles:
		if not marble.visible:
			new_marble = marble
			break

	if new_marble == null:
		return null

	new_marble.translation = (
		piece.translation
		+ Vector3.UP * 5.0
		+ Vector3.FORWARD * (position[0] - 3)
		+ Vector3.RIGHT * (position[1] - 1)
	)
	new_marble.roll()
	return new_marble


func get_highest_piece() -> Piece:
	var pieces = _race.get_children()
	if len(pieces) == 0:
		return null
	var highest_piece = pieces[0]
	for piece in pieces:
		if piece.translation.y > highest_piece.translation.y:
			highest_piece = piece
	return highest_piece


func replace_camera(new_camera, old_cameras) -> void:
	# Ensure old cameras are remove from the current scene
	for camera in old_cameras:
		if camera.is_inside_tree():
			remove_from_tree(camera)
	# And create a new one
	if not new_camera.is_inside_tree():
		add_child(new_camera)


func set_mode(mode):
	var start_a_new_race = false
	var marbles = _marble_pool.get_children()
	var marble_count = 0
	for marble in marbles:
		if marble.visible:
			marble_count += 1

	if mode != _mode:
		if _mode == State.MODE_PAUSE or _mode == State.MODE_START:
			# For each start action, delete all marbles
			if _pause_menu.is_start() or _pause_menu.is_quit():
				start_a_new_race = true
				for marble in marbles:
					marble.pause()
				marble_count = 0

				# Ensure timer is reset
				_race_has_started = false
				_timer.set_wait_time(10)
				_timer.stop()

			# Ensure that the pause menu is close
			if _pause_menu.visible:
				_pause_menu.close()

	_mode = mode

	if _mode == State.MODE_MARBLE:
		# If no marbles exists
		if start_a_new_race:
			_transition.show()
			yield(_transition.tween, "tween_completed")

			_explosion_enabled = SettingsManager.get_value("marbles", "explosion_enabled") as bool
			_race.call_deferred("generate_race", !_explosion_enabled)

			_overlay.reset()
			reset_position()

			# Show HUD
			_overlay.show()

			# Put the camera at the right place for the start
#			_cinematic_camera.set_curve(_race._curve)
			replace_camera(_cinematic_camera, [_rotation_camera])

			var names = _pause_menu.get_names()
			if len(names) > 0:
				# Stop SceneTree, to make all the marbles leave at the same time
				get_tree().set_pause(true)

				# Create one marble for each name
				for name in _pause_menu.get_names():
					var marble = try_place_start_marble()
					if marble == null:
						break
					marble.set_name(name)
					_overlay.add_marble_rank(marble)
					_cinematic_camera.set_target(marble)

			_transition.hide()
			yield(_transition.tween, "tween_completed")

			_countdown.start()

		else:
			_overlay.show()

			replace_camera(_cinematic_camera, [_rotation_camera])

	elif _mode == State.MODE_START:
		_overlay.hide()
		_pause_menu.open_start_menu()
		replace_camera(_rotation_camera, [_cinematic_camera])

	elif _mode == State.MODE_PAUSE:
		_pause_menu.open_pause_menu()
		replace_camera(_rotation_camera, [_cinematic_camera])


func _start_race():
	# Release SceneTree
	get_tree().set_pause(false)
	_timer.start()
	_race_has_started = true


static func remove_from_tree(node):
	node.get_parent().remove_child(node)


func _process(delta):
	_time += delta

	if _time > TIME_PERIOD:
		if _mode == State.MODE_START:
			_race.call_deferred("generate_race", true)
			# Reset timer
			_time = 0

	if _mode != State.MODE_START and _explosion_enabled:
		var time_left := _timer.get_time_left()

		_panel_timer.show()
		_label_timer.set_text("%d:%02d" % [floor((time_left + 1) / 60), int(time_left + 1) % 60])

		if time_left == 0.0 and _race_has_started:
			_timer.start()

			if _ranking._last_marble != null:
				var skip := explosion_victory(_ranking._last_marble)

				if !skip:
					_ranking._last_marble.explode()

					_explosion.global_translation = _ranking._last_marble.global_translation
					_explosion.set_emitting(true)

		if _ranking._first_marble:
			if (
				_need_new_chunk
				and (_ranking._first_marble._checkpoint_count + 3) % _race._step_count != 0
			):
				_race.generate_chunk()
				_need_new_chunk = false
			elif (_ranking._first_marble._checkpoint_count + 3) % _race._step_count == 0:
				_need_new_chunk = true
	else:
		_panel_timer.hide()

	if not _pause_menu.visible:
		if _mode == State.MODE_PAUSE or _mode == State.MODE_START:
			set_mode(State.MODE_MARBLE)
	else:
		if _mode == State.MODE_PAUSE and _pause_menu.is_quit():
			set_mode(State.MODE_START)

	if not _cinematic_camera.has_target() or not _cinematic_camera.get_target().visible:
		var found = false
		for marble in _marbles:
			if marble.visible:
				found = true
				_cinematic_camera.set_target(marble)
				break
		if not found:
			replace_camera(_rotation_camera, [_cinematic_camera])


func explosion_victory(_last_marble: Marble) -> bool:
	var marble_exploded_count := 0
	var tmp_marble = null
	var marbles = _marble_pool.get_children()

	for marble in marbles:
		if !marble.has_explode() and marble.visible:
			marble_exploded_count += 1
			if _last_marble != marble:
				tmp_marble = marble

		if marble_exploded_count > 2:
			break

	if marble_exploded_count == 2:
		tmp_marble.finish()

	if marble_exploded_count == 1:
#		_last_marble.finish()
		return true

	if marble_exploded_count == 0:
		return true

	return false
