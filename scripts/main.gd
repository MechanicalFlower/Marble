class_name Main

extends Node

enum State { MODE_START, MODE_PAUSE, MODE_MARBLE, MODE_FOCUS }

const RotationCamera := preload("res://scenes/camera/rotation_camera.tscn")
const FlyCamera := preload("res://scenes/camera/spectator_camera.tscn")
const FocusCamera := preload("res://scenes/camera/marble_camera.tscn")
const Race := preload("res://scenes/race.tscn")
const MarbleScene := preload("res://scenes/marble.tscn")

const TIME_PERIOD := 5  # 500ms

var Group := load("res://scripts/constants/groups.gd")

var _rotation_camera = null
var _fly_camera = null
var _focus_camera = null
var _mode: int = State.MODE_START
var _current_marble_index := 0
var _time := 0.0

onready var _player_spawn := get_node("%PlayerSpawn") as Spatial
onready var _pause_menu := get_node("%Menu") as Control
onready var _race := get_node("%Race") as Spatial
onready var _crosshair := get_node("%CrosshairContainer") as CenterContainer


func _ready() -> void:
	_rotation_camera = RotationCamera.instance()
	_fly_camera = FlyCamera.instance()
	_focus_camera = FocusCamera.instance()

	_fly_camera.translation = _player_spawn.translation
	_fly_camera.rotate_y(90.0 * PI / 180.0)

	set_mode(_mode)


func _exit_tree():
	if not _rotation_camera.is_inside_tree():
		_rotation_camera.free()
	if not _fly_camera.is_inside_tree():
		_fly_camera.free()
	if not _focus_camera.is_inside_tree():
		_focus_camera.free()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_TAB:
					if _mode == State.MODE_MARBLE or _mode == State.MODE_FOCUS:
						var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
						var marble_count = len(marbles)
						if marble_count != 0:
							if _current_marble_index >= marble_count:
								_current_marble_index = 0
								set_mode(State.MODE_MARBLE)
							else:
								set_mode(State.MODE_FOCUS, marbles[_current_marble_index])
								_current_marble_index += 1
						else:
							print("Could not place start marble")
				KEY_ESCAPE:
					if _mode != State.MODE_START and _mode != State.MODE_PAUSE:
						set_mode(State.MODE_PAUSE)
				# Debug command to spawn a new marble
				KEY_T:
					if _mode == State.MODE_MARBLE:
						try_place_start_marble()
				# Debug command to generate a new race
				KEY_R:
					if _mode == State.MODE_MARBLE:
						_race.call_deferred("generate_race")


func try_place_start_marble():
	var piece = get_highest_piece()
	if piece == null:
		return null
	randomize()
	var marble = MarbleScene.instance()
	marble.translation = (
		piece.translation
		+ Vector3.UP * 5.0
		+ Vector3.FORWARD * ((randi() % 6) - 3)
	)
	add_child(marble)
	return marble


func get_highest_piece():
	var pieces = get_tree().get_nodes_in_group(Group.PIECES)
	if len(pieces) == 0:
		return null
	var highest_piece = pieces[0]
	for piece in pieces:
		if piece.translation.y > highest_piece.translation.y:
			highest_piece = piece
	return highest_piece


func replace_camera(new_camera, old_cameras):
	# Ensure old cameras are remove from the current scene
	for camera in old_cameras:
		if camera.is_inside_tree():
			remove_from_tree(camera)
	# And create a new one
	if not new_camera.is_inside_tree():
		add_child(new_camera)


func set_mode(mode, target_marble = null):
	var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
	var marble_count = len(marbles)

	if mode == State.MODE_FOCUS and _mode != State.MODE_MARBLE and _mode != State.MODE_FOCUS:
		print("Cannot switch to focus mode, you need to be in marble mode first")
		return

	if mode != _mode:
		if _mode == State.MODE_PAUSE or _mode == State.MODE_START:
			# For each start action, delete all marbles
			if _pause_menu.is_start() or _pause_menu.is_quit():
				for marble in marbles:
					marble.queue_free()
				marble_count = 0

			# Ensure that the pause menu is close
			if _pause_menu.visible:
				_pause_menu.close()

	if mode == State.MODE_FOCUS:
		if marble_count == 0:
			print("Cannot switch to focus  mode, there are no marbles")
			return

	_mode = mode

	if _mode == State.MODE_FOCUS:
		print("Switch to focus mode")
		_crosshair.hide()
		replace_camera(_focus_camera, [_fly_camera, _rotation_camera])
		_focus_camera.set_target(target_marble)

	elif _mode == State.MODE_MARBLE:
		print("Switch to marble mode")
		_crosshair.show()
		# If no marbles exists, create one for each name
		if marble_count == 0:
			for name in _pause_menu.get_names():
				var marble = try_place_start_marble()
				marble.set_name(name)
		replace_camera(_fly_camera, [_focus_camera, _rotation_camera])

	elif _mode == State.MODE_START:
		print("Switch to start mode")
		_pause_menu.open_start_menu()
		_crosshair.hide()
		replace_camera(_rotation_camera, [_focus_camera, _fly_camera])

	elif _mode == State.MODE_PAUSE:
		print("Switch to pause mode")
		_pause_menu.open_pause_menu()
		_crosshair.hide()
		replace_camera(_rotation_camera, [_focus_camera, _fly_camera])


static func remove_from_tree(node):
	node.get_parent().remove_child(node)


func _process(delta):
	_time += delta

	if _time > TIME_PERIOD:
		if _mode == State.MODE_START:
			_race.call_deferred("generate_race")
			# Reset timer
			_time = 0

	if not _pause_menu.visible:
		if _mode == State.MODE_PAUSE or _mode == State.MODE_START:
			set_mode(State.MODE_MARBLE)
	else:
		if _mode == State.MODE_PAUSE and _pause_menu.is_quit():
			set_mode(State.MODE_START)

	if not _focus_camera.has_target():
		if _mode == State.MODE_FOCUS:
			set_mode(State.MODE_MARBLE)
