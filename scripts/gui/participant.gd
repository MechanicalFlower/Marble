class_name Participant

extends HBoxContainer

var Group := load("res://scripts/constants/groups.gd")

var _marble: Marble = null
var _last_rank := -1

onready var _rank_label := get_node("%Rank") as Label
onready var _name_label := get_node("%Name") as Label


func _ready() -> void:
	_name_label.set_text(_marble.get_name().to_upper())


func set_rank(rank: int) -> void:
	_last_rank = rank
	_rank_label.set_text(String(rank))


func get_rank() -> int:
	return _last_rank


func set_marble(marble: Marble) -> void:
	_marble = marble


func get_marble() -> Marble:
	return _marble
