extends Area

var Group = load("res://scripts/constants/groups.gd")

onready var _player = get_node("Sound")


func _on_SoundTrigger_body_entered(body):
	if body.is_in_group(Group.MARBLES):
		_player.play()
