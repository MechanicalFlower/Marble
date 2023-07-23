@tool

class_name Race
extends Node

var PieceList = load("res://scripts/constants/piece_list.gd")
var Group = load("res://scripts/constants/groups.gd")

var _step_count := 10
var _previous_piece: Piece = null
var _piece_orientation = null
var _previous_rotation_index := 0
var _curve: Curve3D

@onready var path := get_node(^"Path") as Path3D


static func umod(x: int, d: int) -> int:
	if x < 0:
		return (x + 1) % d + d - 1
	return x % d


func _ready() -> void:
	_curve = Curve3D.new()
	path.set_curve(_curve)

	var explosion_enabled = SettingsManager.get_value(&"marbles", &"explosion_enabled") as bool
	generate_race(!explosion_enabled)


func generate_race(with_end: bool = true) -> void:
	_curve.clear_points()

	for piece in get_children():
		if piece.is_in_group(Group.PIECES):
			piece.queue_free()

	randomize()

	# Reset values
	_previous_piece = null
	_piece_orientation = null
	_previous_rotation_index = 0

	# Place the start line
	place_piece(-2)

	generate_chunk()

	if with_end:
		# Place the finish line
		place_piece(-1)


func generate_chunk():
	for step in _step_count:
		# Select a random piece
		var piece_index = umod(randi(), len(PieceList.PIECES) - 2)
		place_piece(piece_index)


func place_piece(piece_index: int) -> void:
	var piece_data = PieceList.PIECES[piece_index]
	var piece = piece_data[&"resource"].instantiate()

	# Add the piece to the main Node
	add_child(piece)

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
	_piece_orientation = piece_data[&"next_piece_orientation"]
	_previous_rotation_index = rotation_index

	var positions := piece.get_node(^"Positions") as Marker3D
	if positions:
		for pos in positions.get_children():
			_curve.add_point(pos.global_position)
