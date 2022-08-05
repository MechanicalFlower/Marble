class_name FinishLine

extends Area

var Group := load("res://scripts/constants/groups.gd")

onready var _player := get_node("%Sound") as AudioStreamPlayer3D
onready var _ranking := get_node("%Ranking") as VBoxContainer


func _on_Area_body_entered(body: PhysicsBody) -> void:
	# If a marble collide
	if body.is_in_group(Group.MARBLES):
		# Play the final sound
		_player.play()

		# Add its name to the ranking
		_ranking.add_finisher(body.get_name())

		# Delete the marble
		body.queue_free()
