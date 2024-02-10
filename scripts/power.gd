@tool
extends Node3D

enum PowerType { BOOST }

const Group := preload("res://scripts/constants/groups.gd")
const CollisionLayers := preload("res://scripts/constants/collision_layers.gd")

@export var active: bool:
	set = toggle

@export var type: PowerType:
	set = set_type

@onready var area: Area3D = get_node(^"Area3D")
@onready var audio: AudioStreamPlayer3D = get_node(^"AudioStreamPlayer3D")
@onready var mesh: MeshInstance3D = get_node(^"MeshInstance3D")


func _ready():
	toggle(false)

	area.collision_layer = 1 << CollisionLayers.POWERS
	area.collision_mask = 1 << CollisionLayers.MARBLES

	set_type(type)


func toggle(val) -> void:
	active = val
	set_visible(val)
	area.set_monitoring(val)


func set_type(val) -> void:
	type = val

	if mesh:
		# Change the color accordingly to the type of the power
		match type:
			PowerType.BOOST:
				var material: ShaderMaterial = mesh.get_surface_override_material(0)
				material.set_shader_parameter("_shield_color", Color.BLUE)


func _on_area_3d_body_entered(body):
	if body.is_in_group(Group.MARBLES):
		match type:
			PowerType.BOOST:
				body.linear_velocity *= 2
				audio.play()
