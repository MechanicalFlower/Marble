# List of participants, which is updated every frame until the end of the race
class_name Ranking

extends VBoxContainer

var _first_marble: Marble = null
var _last_marble: Marble = null


func update() -> void:
	var children := get_children()

	var arr := []
	for child in children:
		if child is Participant:
			arr.append(child)

	arr.sort_custom(more_checkpoint)

	if len(arr) > 0:
		_first_marble = arr[0].get_marble()

	var rank := 0
	for child in arr:
		move_child(child, rank * 2)
		rank += 1
		child.set_rank(rank)

		var marble = child.get_marble()
		if !marble.has_finish() and marble.is_visible():
			_last_marble = marble


func more_checkpoint(a: Participant, b: Participant) -> bool:
	var a_marble = a.get_marble()
	var b_marble = b.get_marble()

	var out: bool
	if (
		a_marble.has_finish() and b_marble.has_finish()
		or a_marble.get_checkpoint_count() == b_marble.get_checkpoint_count()
	):
		out = a.get_rank() < b.get_rank()
	elif a_marble.has_finish():
		out = true
	elif b_marble.has_finish():
		out = false
	else:
		if a_marble.has_explode() and b_marble.has_explode():
			out = a.get_rank() < b.get_rank()
		elif a_marble.has_explode():
			out = false
		elif b_marble.has_explode():
			out = true
		else:
			out = a_marble.get_checkpoint_count() > b_marble.get_checkpoint_count()
	return out


func reset() -> void:
	for child in get_children():
		child.call_deferred(&"queue_free")
