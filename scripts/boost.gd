@tool
extends Node3D

const Group := preload("res://scripts/constants/groups.gd")
const CollisionLayers := preload("res://scripts/constants/collision_layers.gd")

@export var active: bool:
	set = activate,
	get = is_activated

@onready var area: Area3D = get_node(^"Area3D")
@onready var audio: AudioStreamPlayer3D = get_node(^"AudioStreamPlayer3D")


func _ready():
	activate(false)

	area.collision_layer = 1 << CollisionLayers.BOOSTS
	area.collision_mask = 1 << CollisionLayers.MARBLES


func activate(val) -> void:
	set_visible(val)
	area.set_monitoring(val)


func is_activated() -> bool:
	return is_visible()


func _on_area_3d_body_entered(body):
	if body.is_in_group(Group.MARBLES):
		body.linear_velocity *= 2
		audio.play()
