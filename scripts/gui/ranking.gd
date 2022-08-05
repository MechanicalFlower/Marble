class_name Ranking

extends VBoxContainer

const Finisher := preload("res://scenes/gui/finisher.tscn")


func add_finisher(name: String) -> void:
	var finisher = Finisher.instance()
	finisher.set_text(name)
	add_child(finisher)
