extends Node

const RotateCamera = preload("res://scenes/camera/rotate_camera.tscn")
const FlyAvatarScene = preload("res://scenes/camera/first_person_avatar.tscn")
const FocusAvatarScene = preload("res://scenes/camera/marble_camera.tscn")
const Race = preload("res://scenes/race.tscn")
const MarbleScene = preload("res://scenes/marble.tscn")

const MODE_MARBLE = 0
const MODE_FOCUS = 1
const MODE_START = 2
const MODE_PAUSE = 3

const TIME_PERIOD = 5 # 500ms

var Group = load("res://scripts/constants/groups.gd")

var _rotate_camera = null
var _fly_avatar = null
var _focus_avatar = null
var _race = null
var _mode = MODE_START
var _current_marble_index = 0
var _time = TIME_PERIOD

onready var _player_spawn = get_node("PlayerSpawn")
onready var _pause_menu = get_node("Menu")


func _ready():
	_rotate_camera = RotateCamera.instance()
	_fly_avatar = FlyAvatarScene.instance()
	_focus_avatar = FocusAvatarScene.instance()

	_race = Race.instance()
	add_child(_race)

	_fly_avatar.translation = _player_spawn.translation
	_fly_avatar.rotate_y(90 * PI / 180)

	set_mode(_mode)


func _exit_tree():
	if not _fly_avatar.is_inside_tree():
		_fly_avatar.free()
	if not _focus_avatar.is_inside_tree():
		_focus_avatar.free()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_TAB:
					if _mode == MODE_MARBLE:
						try_place_start_marble()
						var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
						if len(marbles) != 0:
							set_mode(MODE_FOCUS, marbles[_current_marble_index])
							_current_marble_index += 1
						else:
							print("Could not place start marble")
					else:
						set_mode(MODE_MARBLE)
				KEY_ESCAPE:
					if _mode != MODE_PAUSE:
						set_mode(MODE_PAUSE)
				KEY_T:
					if _mode == MODE_MARBLE:
						try_place_start_marble()
				KEY_R:
					if _mode == MODE_MARBLE:
						_race.generate_race()


func try_place_start_marble():
	var piece = get_highest_piece()
	if piece == null:
		return null
	var marble = MarbleScene.instance()
	marble.translation = piece.translation + Vector3.UP * 5.0 + Vector3.FORWARD * ((randi() % 6) - 3)
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
			camera.get_parent().remove_child(camera)
	# And create a new one
	if not new_camera.is_inside_tree():
		add_child(new_camera)


func set_mode(mode, target_marble = null):
	if mode == MODE_FOCUS and _mode != MODE_MARBLE:
		print("Cannot switch to focus  mode, you need to be in marble mode first")
		return

	if mode == MODE_FOCUS:
		var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
		if len(marbles) == 0:
			print("Cannot switch to focus  mode, there are no marbles")
			return

	if (_mode == MODE_PAUSE or _mode == MODE_START) and mode != _mode:
		# Close pause menu
		if _pause_menu.visible:
			_pause_menu.close()

	_mode = mode

	if _mode == MODE_FOCUS:
		print("Switch to focus mode")
		replace_camera(_focus_avatar, [_fly_avatar, _rotate_camera])
		_focus_avatar.set_target(target_marble)

	elif _mode == MODE_MARBLE:
		print("Switch to marble mode")
		replace_camera(_fly_avatar, [_focus_avatar, _rotate_camera])

	elif _mode == MODE_START:
		print("Switch to start mode")
		_pause_menu.open(_pause_menu.MODE_START)
		replace_camera(_rotate_camera, [_focus_avatar, _fly_avatar])

	elif _mode == MODE_PAUSE:
		print("Switch to pause mode")
		_pause_menu.open(_pause_menu.MODE_PAUSE)
		replace_camera(_rotate_camera, [_focus_avatar, _fly_avatar])


static func remove_from_tree(node):
	node.get_parent().remove_child(node)


func _process(delta):
	_time += delta
	if _time > TIME_PERIOD:
		if _mode == MODE_START:
			_race.generate_race()
			# Reset timer
			_time = 0

	if not _pause_menu.visible:
		if _mode == MODE_PAUSE or _mode == MODE_START:
			set_mode(MODE_MARBLE)

	if not _focus_avatar.has_target():
		if _mode == MODE_FOCUS:
			set_mode(MODE_MARBLE)
