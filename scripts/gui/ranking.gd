# List of participants, which is updated every frame until the end of the race
class_name Ranking

extends VBoxContainer


func update() -> void:
	var childs := get_children()

	childs.sort_custom(self, "more_checkpoint")

	var rank := 0
	for child in childs:
		move_child(child, rank)
		rank += 1
		child.set_rank(rank)


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
		out = a_marble.get_checkpoint_count() > b_marble.get_checkpoint_count()
	return out


func reset() -> void:
	for child in get_children():
		child.call_deferred("queue_free")
