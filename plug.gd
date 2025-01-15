extends "res://addons/gd-plug/plug.gd"


func _plugging():
	var deps_str = FileAccess.get_file_as_string("./.godot-deps.json")
	var deps = JSON.parse_string(deps_str)
	for addon in deps["addons"]:
		plug("%s/%s" % [addon["owner", addon["repo"]]], addon)
	
