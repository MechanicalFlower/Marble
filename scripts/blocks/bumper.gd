extends Area

var Group = load("res://scripts/constants/groups.gd")

onready var _animation_player = get_parent().get_node("AnimationPlayer")
onready var _bump_sound = get_node("BumpSound")


func _on_Area_body_entered(body):
	if body.is_in_group(Group.MARBLES):
		_animation_player.play("bump")
		body.apply_central_impulse(Vector3(0, 10, 0))
		_bump_sound.play()
