extends Control

signal countdown_finished

var _count := 4

@onready var _timer: Timer = get_node(^"%Timer")
@onready var _label_timer = get_node(^"%LabelTimer")
@onready var _countdown_1 = get_node(^"Countdown1")
@onready var _countdown_2 = get_node(^"Countdown2")


func _ready():
	_timer.connect("timeout", _decrement_and_play)


func _decrement_and_play():
	_count -= 1
	if _count == 0:
		_countdown_2.play()
		_label_timer.set_text("start")
		_count = 4

		_timer.stop()
		hide()
		emit_signal("countdown_finished")
	else:
		_countdown_1.play()
		_label_timer.set_text(str(_count))


func start():
	show()
	_decrement_and_play()
	_timer.start()
