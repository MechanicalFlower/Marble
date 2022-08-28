class_name Overlay

extends Control

const Participant := preload("res://scenes/gui/participant.tscn")

var Group := load("res://scripts/constants/groups.gd")

onready var _ranking := get_node("%Ranking") as VBoxContainer


func _process(_delta):
	var marbles = get_tree().get_nodes_in_group(Group.MARBLES)
	var marble_count = len(marbles)

	if marble_count > 0:
		_ranking.update()


func add_marble_rank(marble: Marble) -> void:
	# Add the marble to the list of participants
	var participant = Participant.instance()
	participant.set_marble(marble)
	_ranking.add_child(participant)


func reset() -> void:
	_ranking.reset()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if not visible:
				reset()
