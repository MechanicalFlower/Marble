extends Node

var _last_esc_time = 0


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_ESCAPE:
				var now = OS.get_ticks_msec()
				if now - _last_esc_time < 200:
					get_tree().quit()
				else:
					_last_esc_time = now
