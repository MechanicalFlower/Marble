class_name Race

extends Node

var PieceList = load("res://scripts/constants/piece_list.gd")
var Group = load("res://scripts/constants/groups.gd")

var _step_count := 10
var _previous_piece = null
var _piece_orientation = null
var _previous_rotation_index = 0

onready var _main := get_parent() as Node


static func umod(x: int, d: int) -> int:
	if x < 0:
		return (x + 1) % d + d - 1
	return x % d


func _ready() -> void:
	call_deferred("generate_race")


func generate_race() -> void:
	var pieces = get_tree().get_nodes_in_group(Group.PIECES)
	for piece in pieces:
		piece.queue_free()

	randomize()

	# Reset values
	_previous_piece = null
	_piece_orientation = null
	_previous_rotation_index = 0

	# Place the start line
	place_piece(-2)

	for step in _step_count:
		# Select a random piece
		var piece_index = umod(randi(), len(PieceList.PIECES) - 2)
		place_piece(piece_index)

	# Place the finish line
	place_piece(-1)


func place_piece(piece_index: int) -> void:
	var piece_data = PieceList.PIECES[piece_index]
	var piece = piece_data["resource"].instance()

	# Add the piece to the main Node
	_main.add_child(piece)

	# Rotate the piece
	var rotation_index = _previous_rotation_index
	if _piece_orientation == PieceList.TURN_LEFT:
		rotation_index = (rotation_index + 1) % 4
	elif _piece_orientation == PieceList.TURN_RIGHT:
		rotation_index = (rotation_index - 1) % 4
	piece.rotate_y(float(rotation_index) * PI / 2.0)

	# Translate the piece
	var offset = Vector3(-10, 25, 0)
	if _previous_piece != null:
		offset = (
			_previous_piece.get_end().global_transform.origin
			- piece.get_begin().global_transform.origin
		)
	piece.global_translate(offset)

	# Store data for next piece
	_previous_piece = piece
	_piece_orientation = piece_data["next_piece_orientation"]
	_previous_rotation_index = rotation_index
