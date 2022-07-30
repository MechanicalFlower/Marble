extends Node

const EditAvatarScene = preload("res://scenes/first_person_avatar.tscn")
const MarbleAvatarScene = preload("res://scenes/marble_camera.tscn")
const MarbleScene = preload("res://scenes/marble.tscn")

const MODE_EDIT = 0
const MODE_MARBLE = 1

var Group = load("res://scripts/groups.gd")

var _edit_avatar = null
var _marble_avatar = null
var _mode = MODE_EDIT

onready var _player_spawn = get_node("PlayerSpawn")
onready var _pause_menu = get_node("Menu")
onready var _load_sound = get_node("LoadSound")
onready var _save_sound = get_node("SaveSound")


func _ready():
	_edit_avatar = EditAvatarScene.instance()
	_marble_avatar = MarbleAvatarScene.instance()

	_edit_avatar.translation = _player_spawn.translation

	set_mode(MODE_EDIT)


func _exit_tree():
	if not _edit_avatar.is_inside_tree():
		_edit_avatar.free()
	if not _marble_avatar.is_inside_tree():
		_marble_avatar.free()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_M:
					try_place_start_marble()
				KEY_TAB:
					if _mode == MODE_EDIT:
						var marble = try_place_start_marble()
						if marble != null:
							set_mode(MODE_MARBLE, marble)
						else:
							print("Could not place start marble")
					else:
						set_mode(MODE_EDIT)
				KEY_ESCAPE:
					if _mode == MODE_MARBLE:
						set_mode(MODE_EDIT)
					else:
						if _pause_menu.visible:
							_pause_menu.close()
						else:
							_pause_menu.show()


#				KEY_K:
#					save_machine()
#				KEY_L:
#					load_machine()


func try_place_start_marble():
	var piece = get_highest_piece()
	if piece == null:
		return null
	var marble = MarbleScene.instance()
	marble.translation = piece.translation + Vector3.UP * 5.0
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


func set_mode(mode, target_marble = null):
	_mode = mode

	if _mode == MODE_MARBLE:
		var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
		if len(marbles) == 0:
			print("Cannot switch to marble mode, there are no marbles")
			return
		print("Switch to marble mode")
		if _edit_avatar.is_inside_tree():
			remove_from_tree(_edit_avatar)
		if not _marble_avatar.is_inside_tree():
			add_child(_marble_avatar)
		_marble_avatar.set_target(target_marble)

	else:
		print("Switch to edit mode")
		if _marble_avatar.is_inside_tree():
			_marble_avatar.get_parent().remove_child(_marble_avatar)
		if not _edit_avatar.is_inside_tree():
			add_child(_edit_avatar)


static func remove_from_tree(node):
	node.get_parent().remove_child(node)


func _process(_delta):
	var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
	if not _marble_avatar.has_target():
		if _mode == MODE_MARBLE:
			set_mode(MODE_EDIT)


func save_machine(fpath):
	var pieces = get_tree().get_nodes_in_group(Group.PIECES)
	var pieces_data = []
	for piece in pieces:
		var pos = piece.translation
		var rot = piece.rotation
		var piece_data = {
			"type": piece.filename,
			"position": [pos.x, pos.y, pos.z],
			"rotation": [rot.x, rot.y, rot.z]
		}
		pieces_data.push_back(piece_data)
	var data = {"pieces": pieces_data}
	var json = JSON.print(data, "\t", true)
	var f = File.new()
	var err = f.open(fpath, File.WRITE)
	if err != OK:
		print("Could not save file ", fpath, ", error ", err)
		return
	f.store_string(json)
	f.close()


static func array_to_vec3(a):
	return Vector3(a[0], a[1], a[2])


func load_machine(fpath):
	var f = File.new()
	var err = f.open(fpath, File.READ)
	if err != OK:
		print("Could not open file ", fpath, ", error ", err)
		return
	var json = f.get_as_text()
	var json_res = JSON.parse(json)
	if json_res.error != OK:
		print("Error when loading json ", fpath, ": ", json_res.error_string)
		return
	var data = json_res.result

	var pieces = get_tree().get_nodes_in_group(Group.PIECES)
	for piece in pieces:
		piece.queue_free()

	for piece_data in data.pieces:
		var piece_scene = load(piece_data.type)
		var piece = piece_scene.instance()
		var pos = array_to_vec3(piece_data.position)
		var rot = array_to_vec3(piece_data.rotation)
		piece.translation = pos
		piece.rotation = rot
		add_child(piece)
		piece.set_ghost(false)


func _on_Menu_load_path_selected(fpath):
	load_machine(fpath)
	_load_sound.play()


func _on_Menu_save_path_selected(fpath):
	save_machine(fpath)
	_save_sound.play()
