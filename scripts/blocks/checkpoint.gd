# SPDX-FileCopyrightText: 2023 Florian Vazelle <florian.vazelle@vivaldi.net>
#
# SPDX-License-Identifier: MIT

class_name Checkpoint

extends Area

var Group := load("res://scripts/constants/groups.gd")

var _marbles: PoolStringArray = []


func _ready() -> void:
	connect("body_entered", self, "_on_EndArea_body_entered")


func _on_EndArea_body_entered(body: PhysicsBody) -> void:
	# If a marble collide
	if body.is_in_group(Group.MARBLES):
		var marble_name = body.get_name()
		if not _marbles.has(marble_name):
			_marbles.push_back(marble_name)
			body.incr_checkpoint_count()
