extends "res://scripts/main.gd"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_SPACE and event.is_pressed():
		for marble in _marbles:
			var marble_name = marble.get_name().to_lower()
			if marble_name == "maxime" or marble_name == "max":
				marble.set_linear_velocity(-marble.linear_velocity * 2)
				break
