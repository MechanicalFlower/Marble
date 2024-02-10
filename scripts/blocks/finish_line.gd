class_name FinishLine

extends Area3D

const Group := preload("res://scripts/constants/groups.gd")

@onready var _player := get_node(^"%Sound") as AudioStreamPlayer3D


func _on_Area_body_entered(body: PhysicsBody3D) -> void:
	# If a marble collide
	if body.is_in_group(Group.MARBLES):
		# Play the final sound
		_player.play()

		body.finish()
