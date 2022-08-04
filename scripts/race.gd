extends Node

var PieceList = load("res://scripts/constants/piece_list.gd")
var Group = load("res://scripts/constants/groups.gd")

var _step_count = 10
var _old_ghost = null
var _previous_info_piece = null
var _previous_rotation_index = 0

onready var _machine = get_parent()


static func umod(x, d):
	if x < 0:
		return (x + 1) % d + d - 1
	return x % d


func generate_race():
	for child in _machine.get_children():
		if child.is_in_group("race_pieces"):
			_machine.remove_child(child)
			child.queue_free()

	randomize()

	_old_ghost = null
	_previous_info_piece = null
	_previous_rotation_index = 0

	place_piece(-2)
	for step in _step_count:
		# select a random piece
		var piece_index = umod(randi(), len(PieceList.PIECES) - 2)
		place_piece(piece_index)
	place_piece(-1)


func place_piece(piece_index):
	# make a ghost piece
	var piece = PieceList.PIECES[piece_index]
	var ghost = piece.instance()
	_machine.add_child(ghost)
	ghost.add_to_group("race_pieces")

	var rotation_index = _previous_rotation_index
	if _previous_info_piece == PieceList.TURN_LEFT:
		rotation_index = (rotation_index + 1) % 4
	elif _previous_info_piece == PieceList.TURN_RIGHT:
		rotation_index = (rotation_index - 1) % 4
	ghost.rotate_y(float(rotation_index) * PI / 2.0)

	var offset = Vector3(-10, 25, 0)
	if _old_ghost != null:
		offset = _old_ghost.get_end().global_transform.origin - ghost.get_begin().global_transform.origin
	ghost.global_translate(offset)
	ghost.set_ghost(false)

	_old_ghost = ghost
	_previous_info_piece = PieceList.INFOS[piece_index]
	_previous_rotation_index = rotation_index
