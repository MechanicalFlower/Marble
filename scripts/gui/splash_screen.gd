extends Control

export(PackedScene) var move_to_scene


func _on_AnimatedSprite_animation_finished():
	var result = get_tree().change_scene_to(move_to_scene)
	if result != OK:
		print("Unable to change scene")
