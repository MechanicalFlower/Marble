extends Control

signal save_path_selected(fpath)
signal load_path_selected(fpath)

var _file_dialog = null

onready var _open_sound = get_node("OpenSound")
onready var _volume_slider = get_node("Panel/VBoxContainer/HBoxContainer/MusicVolumeSlider")


func _ready():
	var fd = FileDialog.new()
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.add_filter("*.marble ; Marble files")
	#fd.current_dir = OS.get_executable_path()
	fd.hide()
	fd.connect("file_selected", self, "_on_FileDialog_file_selected")
	add_child(fd)
	_file_dialog = fd

	var music_bus = AudioServer.get_bus_index("Music")
	_volume_slider.value = db2linear(AudioServer.get_bus_volume_db(music_bus))


func close():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_ResumeButton_pressed():
	close()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_SaveButton_pressed():
	_file_dialog.mode = FileDialog.MODE_SAVE_FILE
	_file_dialog.popup_centered_ratio()


func _on_LoadButton_pressed():
	_file_dialog.mode = FileDialog.MODE_OPEN_FILE
	_file_dialog.popup_centered_ratio()


func _on_FileDialog_file_selected(fpath):
	if _file_dialog.mode == FileDialog.MODE_OPEN_FILE:
		emit_signal("load_path_selected", fpath)
	else:
		emit_signal("save_path_selected", fpath)
	close()


func _notification(what):
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible:
				_open_sound.play()
				#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_MusicVolumeSlider_value_changed(value):
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear2db(value))
