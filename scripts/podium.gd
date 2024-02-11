extends Node3D


func set_first(marble: Marble):
	if marble:
		marble.global_position = get_node(^"FirstPlace/Marker3D").global_position
		marble.visible = true


func set_second(marble: Marble):
	if marble:
		marble.global_position = get_node(^"SecondPlace/Marker3D").global_position
		marble.visible = true


func set_third(marble: Marble):
	if marble:
		marble.global_position = get_node(^"ThirdPlace/Marker3D").global_position
		marble.visible = true
