class_name Piece

extends StaticBody

const CollisionLayers := preload("res://scripts/constants/collision_layers.gd")
const DefaultPieceMaterial := preload("res://resources/materials/piece.tres")

export var empty_material_override := false

var Group := load("res://scripts/constants/groups.gd")

onready var _begin_area := get_node("%BeginArea") as Area
onready var _end_area := get_node("%EndArea") as Area


func _init() -> void:
	add_to_group(Group.PIECES)


func _ready() -> void:
	# Setup collision layers
	collision_layer = 1 << CollisionLayers.PROPS
	_begin_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
	_end_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS | 1 << CollisionLayers.PROPS

	set_material()


func set_material() -> void:
	var mat = null

	if not empty_material_override:
		mat = DefaultPieceMaterial

	for i in get_child_count():
		var child = get_child(i)
		if child is MeshInstance:
			child.material_override = mat


func get_begin() -> Area:
	return _begin_area


func get_end() -> Area:
	return _end_area
