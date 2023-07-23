class_name Checkpoint

extends Area3D

var Group := load("res://scripts/constants/groups.gd")

var _marbles: PackedStringArray = []


func _ready() -> void:
	connect(&"body_entered", _on_EndArea_body_entered)


func _on_EndArea_body_entered(body: PhysicsBody3D) -> void:
	# If a marble collide
	if body.is_in_group(Group.MARBLES):
		var marble_name = body.get_marble_name()
		if not _marbles.has(marble_name):
			_marbles.push_back(marble_name)
			body.incr_checkpoint_count()
