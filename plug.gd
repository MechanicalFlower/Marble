extends "res://addons/gd-plug/plug.gd"


func _plugging():
	plug(
		"godot-extended-libraries/godot-debug-menu",
		{"commit": "f8d1202df122f7e8227ec3a7bdcff745e9780d52", "renovate-branch": "master"}
	)
	plug(
		"KoBeWi/Godot-Universal-Fade",
		{"commit": "f091514bba652880f81c5bc8809e0ee4498988ea", "renovate-branch": "master"}
	)
	plug(
		"nisovin/godot-coi-serviceworker",
		{"commit": "de1be2989eda4c7d77a08b8c56cd94c769181c4e", "renovate-branch": "main"}
	)
