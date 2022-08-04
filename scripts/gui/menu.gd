extends Control

const MODE_START = 1
const MODE_PAUSE = 2

var _mode = MODE_START

onready var _open_sound = get_node("OpenSound")
onready var _input = get_node("Panel/VBoxContainer/TextEdit")
onready var _start_button = get_node("Panel/VBoxContainer/StartButton")
onready var _resume_button = get_node("Panel/VBoxContainer/ResumeButton")
onready var _restart_button = get_node("Panel/VBoxContainer/RestartButton")


func _ready():
	pass


func set_mode(mode):
	_mode = mode

	if _mode == MODE_START:
		_input.show()
		_start_button.show()
		_resume_button.hide()
		_restart_button.hide()
	elif _mode == MODE_PAUSE:
		_input.hide()
		_start_button.hide()
		_resume_button.show()
		_restart_button.show()


func open(mode = MODE_START):
	set_mode(mode)
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_StartButton_pressed():
	close()


func _on_ResumeButton_pressed():
	close()


func _on_QuitButton_pressed():
	if _mode == MODE_START:
		get_tree().quit()
	elif _mode == MODE_PAUSE:
		set_mode(MODE_START)


func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible:
				_open_sound.play()
				# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
