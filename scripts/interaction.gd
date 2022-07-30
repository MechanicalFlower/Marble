extends Node

const CollisionLayers = preload("res://scripts/collision_layers.gd")
const MarbleScene = preload("res://scenes/marble.tscn")

var PieceList = load("res://scripts/piece_list.gd")
var Group = load("res://scripts/groups.gd")

var _ghost = null
var _current_piece_index = 0
var _overlapping_pieces = []
var _floor_height = 0
var _rotation_index = 0
var _pointed_piece = null

onready var _machine = get_parent().get_parent()
onready var _camera = get_parent().get_node("Camera")
onready var _select_sound = get_node("Select")
onready var _select_sound2 = get_node("Select2")
onready var _rotate_sound = get_node("Rotate")
onready var _place_sound = get_node("Place")
onready var _pick_sound = get_node("Pick")
onready var _no_sound = get_node("No")
onready var _remove_sound = get_node("Remove")
onready var _nudge_up_sound = get_node("NudgeUp")
onready var _nudge_down_sound = get_node("NudgeDown")


static func umod(x, d):
	if x < 0:
		return (x + 1) % d + d - 1
	return x % d


func _enter_tree():
	call_deferred("set_current_piece", 0)


func _exit_tree():
	if _ghost != null:
		_ghost.queue_free()
		_ghost = null


func set_current_piece(i):
	_current_piece_index = i
	make_ghost()


func place_piece():
	_ghost.set_ghost(false)
	_ghost = null
	make_ghost()
	_place_sound.play()


func make_ghost():
	var piece = PieceList.PIECES[_current_piece_index]
	if _ghost != null:
		_ghost.queue_free()
	_ghost = piece.instance()
	update_ghost_rotation()
	_machine.add_child(_ghost)
	_ghost.set_ghost(true)


func erase_piece():
	if _pointed_piece != null:
		_pointed_piece.queue_free()
		_pointed_piece = null


func _physics_process(_delta):
	assert(is_inside_tree())
	if _ghost == null:
		return

	var state = get_viewport().world.direct_space_state

	update_overlapping_pieces(state)

	# TODO https://github.com/godotengine/godot/issues/29559
	#var mpos = get_viewport().get_mouse_position()
	var mpos = get_viewport().size / 2.0
	var ray_origin = _camera.project_ray_origin(mpos)
	var ray_direction = _camera.project_ray_normal(mpos)

	update_ghost_position(state, ray_origin, ray_direction)
	update_pointed_piece(state, ray_origin, ray_direction)


func update_ghost_position(state, ray_origin, ray_direction):
	var con_hit = state.intersect_ray(
		ray_origin,
		ray_origin + ray_direction * 50.0,
		[],
		1 << CollisionLayers.CONNECTION_AREAS,
		false,
		true
	)

	var enable_snap = not Input.is_key_pressed(KEY_CONTROL)

	if enable_snap and not con_hit.empty():
		var con_pos = con_hit.collider.global_transform.origin
		var is_begin = con_hit.collider.name.find("Begin") != -1
		var offset = Vector3()
		var con
		if is_begin:
			con = _ghost.get_end()
			offset = _ghost.global_transform.origin - con.global_transform.origin
		else:
			con = _ghost.get_begin()
			offset = _ghost.global_transform.origin - con.global_transform.origin
		_ghost.translation = con_pos + offset

	else:
		var pos = ray_origin + ray_direction * 10.0
		_ghost.translation = pos


func update_pointed_piece(state, ray_origin, ray_direction):
	var piece_hit = state.intersect_ray(
		ray_origin, ray_origin + ray_direction * 50.0, [], 1 << CollisionLayers.PROPS, true, false
	)
	if piece_hit.empty():
		_pointed_piece = null
	else:
		if piece_hit.collider.is_in_group(Group.PIECES):
			_pointed_piece = piece_hit.collider
		else:
			_pointed_piece = null


func update_overlapping_pieces(state):
	var q = PhysicsShapeQueryParameters.new()
	var shape = BoxShape.new()
	shape.extents = Vector3(1, 1, 1) * 0.4
	q.set_shape(shape)
	q.transform = Transform(Basis(), _ghost.translation)
	q.collide_with_areas = false
	var hits = state.intersect_shape(q)

	_overlapping_pieces.clear()
	for hit in hits:
		_overlapping_pieces.append(hit.collider)


#static func min_int(a, b):
#	return a if a < b else b
#
#static func max_int(a, b):
#	return a if a > b else b


func set_rotation_index(i):
	_rotation_index = i % 4
	update_ghost_rotation()


func update_ghost_rotation():
	_ghost.rotation = Vector3(0, float(_rotation_index) * PI / 2.0, 0)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_LEFT:
					if len(_overlapping_pieces) == 0:
						place_piece()
					else:
						print(len(_overlapping_pieces), " pieces are overlapping")
						_no_sound.play()
				BUTTON_RIGHT:
					erase_piece()
					_remove_sound.play()
				BUTTON_WHEEL_DOWN:
					set_current_piece(umod(_current_piece_index + 1, len(PieceList.PIECES)))
					_select_sound.play()
				BUTTON_WHEEL_UP:
					set_current_piece(umod(_current_piece_index - 1, len(PieceList.PIECES)))
					_select_sound2.play()
				BUTTON_MIDDLE:
					if _pointed_piece != null:
						set_current_piece(_pointed_piece.get_piece_index(PieceList.PIECES))
						_pick_sound.play()

	elif event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_R:
					set_rotation_index(_rotation_index + 1)
					_rotate_sound.play()
#				KEY_M:
#					var marble = MarbleScene.instance()
#					marble.translation = _ghost.translation
#					_machine.add_child(marble)
				KEY_PAGEUP:
					nudge_all_pieces(Vector3(0, 1, 0))
					_nudge_up_sound.play()
				KEY_PAGEDOWN:
					nudge_all_pieces(Vector3(0, -1, 0))
					_nudge_down_sound.play()


func nudge_all_pieces(offset):
	var pieces = get_tree().get_nodes_in_group(Group.PIECES)
	for piece in pieces:
		piece.translation += offset
