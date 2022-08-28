class_name Checkpoint

extends Area

var Group := load("res://scripts/constants/groups.gd")


func _ready() -> void:
	connect("body_entered", self, "_on_EndArea_body_entered")


func _on_EndArea_body_entered(body: PhysicsBody) -> void:
	# If a marble collide
	if body.is_in_group(Group.MARBLES):
		body.incr_checkpoint_count()
