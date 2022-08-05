class_name Menu

extends Control

enum State { MODE_OFF, MODE_START, MODE_PAUSE }
enum Action { ACTION_NOOP, ACTION_START, ACTION_RESUME, ACTION_QUIT }

var _mode: int = State.MODE_START
var _last_action: int = Action.ACTION_NOOP

onready var _open_sound := get_node("%OpenSound") as AudioStreamPlayer
onready var _input := get_node("%Input") as TextEdit
onready var _start_button := get_node("%StartButton") as Button
onready var _resume_button := get_node("%ResumeButton") as Button
onready var _restart_button := get_node("%RestartButton") as Button


func _ready() -> void:
	set_mode(_mode)


func _on_StartButton_pressed() -> void:
	_last_action = Action.ACTION_START
	set_mode(State.MODE_OFF)


func _on_ResumeButton_pressed() -> void:
	_last_action = Action.ACTION_RESUME
	set_mode(State.MODE_OFF)


func _on_QuitButton_pressed() -> void:
	_last_action = Action.ACTION_QUIT
	if _mode == State.MODE_START:
		get_tree().quit()
	elif _mode == State.MODE_PAUSE:
		set_mode(State.MODE_START)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible:
				_open_sound.play()


func get_names() -> PoolStringArray:
	var input_text = _input.get_text()
	if input_text:
		return input_text.split(",")
	return PoolStringArray()


func set_mode(mode: int) -> void:
	_mode = mode

	if _mode == State.MODE_START:
		_input.show()
		_start_button.show()
		_resume_button.hide()
		_restart_button.hide()
	elif _mode == State.MODE_PAUSE:
		_input.hide()
		_start_button.hide()
		_resume_button.show()
		_restart_button.show()

	if _mode == State.MODE_START or _mode == State.MODE_PAUSE:
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif _mode == State.MODE_OFF:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func open_start_menu() -> void:
	set_mode(State.MODE_START)


func open_pause_menu() -> void:
	set_mode(State.MODE_PAUSE)


func close() -> void:
	set_mode(State.MODE_OFF)


func is_start() -> bool:
	return _last_action == Action.ACTION_START


func is_resume() -> bool:
	return _last_action == Action.ACTION_RESUME


func is_quit() -> bool:
	return _last_action == Action.ACTION_QUIT
