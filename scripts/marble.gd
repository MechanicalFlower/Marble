class_name Marble

extends RigidBody

const CollisionLayers := preload("res://scripts/constants/collision_layers.gd")

var Group = load("res://scripts/constants/groups.gd")

var _checkpoint_count := 0
var _has_finish := false

onready var _name := get_node("%Name") as Label3D


func _ready() -> void:
	randomize()
	add_to_group(Group.MARBLES)

	# Set material color
	var material = get_node("MeshInstance").get_active_material(0)
	material.set_shader_param("albedo", Color(randf(), randf(), randf()))
	get_node("MeshInstance").set_surface_material(0, material)

	# Set collision mask
	var collision_enabled = SettingsManager.get_value("marbles", "collision_enabled") as bool
	if collision_enabled:
		collision_mask = 1 << CollisionLayers.PROPS | 1 << CollisionLayers.MARBLES
	else:
		collision_mask = 1 << CollisionLayers.PROPS


func incr_checkpoint_count() -> void:
	_checkpoint_count += 1


func get_checkpoint_count() -> int:
	return _checkpoint_count


func set_has_finish(has_finish: bool) -> void:
	_has_finish = has_finish


func has_finish() -> bool:
	return _has_finish


func set_name(name: String) -> void:
	_name.set_text(name)


func get_name() -> String:
	return _name.get_text()


func _process(_delta: float) -> void:
	if translation.y < -100:
#		print("Marble is too low, freeing")
		free_marble()
	var offset := global_transform.origin + Vector3(0, 0.5, 0)
	_name.global_transform.origin = offset


func free_marble() -> void:
#	queue_free()
	hide()
	set_process(false)
