class_name Participant

extends HBoxContainer

const IconConfetti := preload("res://assets/icons/icons8-confetti-100.png")
const IconTrophy := preload("res://assets/icons/icons8-trophy-100.png")
const IconBang := preload("res://assets/icons/icons8-bang-100.png")
const IconSkull := preload("res://assets/icons/icons8-skull-100.png")

var Group := load("res://scripts/constants/groups.gd")

var _marble: Marble = null
var _last_rank := -1

onready var _rank_label := get_node("%Rank") as Label
onready var _name_label := get_node("%Name") as Label
onready var _state := get_node("%State") as NinePatchRect


func _ready() -> void:
	_name_label.set_text(_marble.get_name().to_upper())


func set_rank(rank: int) -> void:
	_last_rank = rank
	_rank_label.set_text(String(rank))

	if _marble.has_finish():
		if rank == 1:
			_state.texture = IconTrophy
		else:
			_state.texture = IconConfetti

	elif _marble.has_explode():
		if _state.texture == null:
			Shake.shake(1, 1)
		_state.texture = IconBang

	elif _marble.has_oob():
		_state.texture = IconSkull


func get_rank() -> int:
	return _last_rank


func set_marble(marble: Marble) -> void:
	_marble = marble


func get_marble() -> Marble:
	return _marble
