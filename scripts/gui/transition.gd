extends ColorRect

onready var tween := get_node("Tween") as Tween


func show():
	tween.interpolate_property(
		material, "shader_param/progress", 0, 1, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	tween.start()


func hide():
	tween.interpolate_property(
		material, "shader_param/progress", 1, 0, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	tween.start()
