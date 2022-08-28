class_name FinishLine

extends Area

var Group := load("res://scripts/constants/groups.gd")

onready var _player := get_node("%Sound") as AudioStreamPlayer3D


func _on_Area_body_entered(body: PhysicsBody) -> void:
	# If a marble collide
	if body.is_in_group(Group.MARBLES):
		# Play the final sound
		_player.play()

		body.set_has_finish(true)

		# Delete the marble
		body.free_marble()
