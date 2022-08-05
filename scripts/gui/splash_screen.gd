class_name SplashScreen

extends Control

export(PackedScene) var move_to_scene = null


func _on_AnimatedSprite_animation_finished() -> void:
	var result = get_tree().change_scene_to(move_to_scene)
	if result != OK:
		printerr("Unable to change scene!")
