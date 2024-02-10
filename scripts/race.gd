@tool
class_name Race
extends Node

# Constants and resource paths
const PieceList = preload("res://scripts/constants/piece_list.gd")
const Group = preload("res://scripts/constants/groups.gd")

@export var regenerate_race: bool:
	set = generate_race

# Number of steps in the race generation
var _step_count := 10

var _previous_piece = null
var _previous_piece_orientation = null
var _previous_rotation_index := 0

# Curve to store the race path
@onready var curve: Curve3D = Curve3D.new()

# Reference to the path node
@onready var path := get_node(^"Path") as Path3D


static func umod(x: int, d: int) -> int:
	if x < 0:
		return (x + 1) % d + d - 1
	return x % d


func _ready() -> void:
	# Initialize the curve and set it to the path
	path.set_curve(curve)

	# Check if explosion is enabled from settings
	var explosion_enabled = SettingsManager.get_value(&"marbles", &"explosion_enabled") as bool
	generate_race(!explosion_enabled)


# Main function to generate the race
func generate_race(with_end: bool = true) -> void:
	# Clear previous race path
	curve.clear_points()
	# Clear previous pieces from the scene
	clear_previous_pieces()
	# Place the start line
	place_start_line()

	# Generate a race chunk
	generate_chunk()

	# Place the finish line if required
	if with_end:
		place_finish_line()


# Function to generate a race chunk
func generate_chunk() -> void:
	randomize()

	for _i in range(_step_count):
		# Select a random piece and place it
		var piece_index = randomize_piece_index()
		place_piece(piece_index)


# Function to clear previous pieces from the scene
func clear_previous_pieces() -> void:
	_previous_piece = null
	_previous_piece_orientation = null
	_previous_rotation_index = 0

	for piece in get_children():
		if piece.is_in_group(Group.PIECES):
			piece.queue_free()


# Function to select a random piece index
func randomize_piece_index() -> int:
	return umod(randi(), len(PieceList.PIECES) - 2)


# Function to place the start line
func place_start_line() -> void:
	place_piece(-2)


# Function to place the finish line
func place_finish_line() -> void:
	place_piece(-1)


# Function to place a piece on the race path
func place_piece(piece_index: int) -> void:
	# Instantiate the piece
	var piece_data = PieceList.PIECES[piece_index]
	var piece: Piece = piece_data[&"resource"].instantiate()

	# Optimize piece visibility
	optimize_piece_visibility(piece)

	# Add the piece to the scene
	add_child(piece)

	# Rotate and translate the piece
	rotate_piece(piece)
	translate_piece(piece)

	# Store data for next piece and positions for the race path
	store_piece_data(piece, piece_data)
	store_piece_positions(piece)


# Function to optimize piece visibility
func optimize_piece_visibility(piece: Piece) -> void:
	for child in piece.get_children():
		if child is MeshInstance3D:
			child.visibility_range_end = 150


# Function to rotate a piece based on previous orientation
func rotate_piece(piece: Piece) -> void:
	var rotation_index = calculate_rotation_index(piece)
	piece.rotate_y(float(rotation_index) * PI / 2.0)


# Function to calculate the rotation index for a piece
func calculate_rotation_index(_piece: Piece) -> int:
	var rotation_index = _previous_rotation_index
	if _previous_piece_orientation == PieceList.TURN_LEFT:
		rotation_index = (rotation_index + 1) % 4
	elif _previous_piece_orientation == PieceList.TURN_RIGHT:
		rotation_index = (rotation_index - 1) % 4
	return rotation_index


# Function to translate a piece based on previous piece position
func translate_piece(piece: Piece) -> void:
	var offset = calculate_translation_offset(piece)
	piece.global_translate(offset)


# Function to calculate the translation offset for a piece
func calculate_translation_offset(piece: Piece) -> Vector3:
	var offset = Vector3(-10, 25, 0)
	if _previous_piece != null:
		offset = (
			_previous_piece.get_end().global_transform.origin
			- piece.get_begin().global_transform.origin
		)
	return offset


# Function to store data for the next piece
func store_piece_data(piece: Piece, piece_data: Dictionary) -> void:
	_previous_piece = piece
	_previous_rotation_index = calculate_rotation_index(piece)
	_previous_piece_orientation = piece_data[&"next_piece_orientation"]


# Function to store positions for the race path
func store_piece_positions(piece: Piece) -> void:
	var positions := piece.get_node(^"Positions") as Marker3D
	if positions:
		for pos in positions.get_children():
			curve.add_point(pos.global_position)
