const PIECES = [
	# forward
	preload("res://scenes/blocks/forward_down.tscn"),
#	preload("res://scenes/blocks/forward.tscn"),
#	preload("res://scenes/blocks/forward_up.tscn"),
	# turn
	preload("res://scenes/blocks/turn_left_covered.tscn"),
	preload("res://scenes/blocks/turn_left_2.tscn"),
	preload("res://scenes/blocks/turn_left_3.tscn"),
	preload("res://scenes/blocks/turn_right_covered.tscn"),
	preload("res://scenes/blocks/turn_right_2.tscn"),
	preload("res://scenes/blocks/turn_right_3.tscn"),
	# hopper
	preload("res://scenes/blocks/hopper.tscn"),
	preload("res://scenes/blocks/hopper2.tscn"),
	preload("res://scenes/blocks/hopper3.tscn"),
	# other
	# preload("res://scenes/blocks/looping.tscn"),
	# preload("res://scenes/blocks/tube_vertical_to_horizontal.tscn"),
	# preload("res://scenes/blocks/bumper.tscn"),
	preload("res://scenes/blocks/standing_start.tscn"),
	preload("res://scenes/blocks/finish_line.tscn")
]

const FINISH = 0
const FORWARD = 1
const TURN_LEFT = 2
const TURN_RIGHT = 3

const INFOS = [
	FORWARD, # FORWARD, FORWARD,
	TURN_LEFT, TURN_LEFT, TURN_LEFT, TURN_RIGHT, TURN_RIGHT, TURN_RIGHT,
	FORWARD, FORWARD, FORWARD,
	FORWARD, FORWARD, # FORWARD, FORWARD, FORWARD
]
