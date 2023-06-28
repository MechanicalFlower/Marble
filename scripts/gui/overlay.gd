# SPDX-FileCopyrightText: 2023 Florian Vazelle <florian.vazelle@vivaldi.net>
#
# SPDX-License-Identifier: MIT

class_name Overlay

extends Control

const Participant := preload("res://scenes/gui/participant.tscn")

var Group := load("res://scripts/constants/groups.gd")

onready var _ranking := get_node("%Ranking") as Ranking
onready var _marble_pool = get_tree().get_nodes_in_group("marble_pool")[0]


func _process(_delta):
	var marble_count = _marble_pool.get_child_count()

	if marble_count > 0:
		_ranking.update()


func add_marble_rank(marble: Marble) -> void:
	# Add the marble to the list of participants
	var participant = Participant.instance()
	participant.set_marble(marble)
	_ranking.add_child(participant)
	_ranking.add_child(HSeparator.new())


func reset() -> void:
	_ranking.reset()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if not visible:
				reset()
