@tool

class_name Piece

extends StaticBody3D

const CollisionLayers := preload("res://scripts/constants/collision_layers.gd")
const DefaultPieceMaterial := preload("res://resources/materials/piece.tres")
const Group := preload("res://scripts/constants/groups.gd")

@export var empty_material_override := false

@onready var _begin_area := get_node(^"%BeginArea") as Area3D
@onready var _end_area := get_node(^"%EndArea") as Area3D


func _init() -> void:
	add_to_group(Group.PIECES)


func _ready() -> void:
	# Setup collision layers
	collision_layer = 1 << CollisionLayers.PROPS
	collision_mask = 0

	_begin_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
	_begin_area.collision_mask = 1 << CollisionLayers.MARBLES

	_end_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
	_end_area.collision_mask = 1 << CollisionLayers.MARBLES

	set_material()


func set_material() -> void:
	var mat = null

	if not empty_material_override:
		mat = DefaultPieceMaterial

	for i in get_child_count():
		var child = get_child(i)
		if child is MeshInstance3D:
			child.material_override = mat


func get_begin() -> Area3D:
	return _begin_area


func get_end() -> Area3D:
	return _end_area
