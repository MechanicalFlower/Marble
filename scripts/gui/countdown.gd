extends Control

@onready var _label_timer = get_node(^"%LabelTimer")
@onready var _countdown_1 = get_node(^"Countdown1")
@onready var _countdown_2 = get_node(^"Countdown2")


func start():
	show()

	_countdown_1.play()
	_label_timer.set_text("3")

	await get_tree().create_timer(1.0).timeout
	_countdown_1.play()
	_label_timer.set_text("2")

	await get_tree().create_timer(1.0).timeout
	_countdown_1.play()
	_label_timer.set_text("1")

	await get_tree().create_timer(1.0).timeout
	_countdown_2.play()
	_label_timer.set_text("start")

	await get_tree().create_timer(1.0).timeout

	hide()
