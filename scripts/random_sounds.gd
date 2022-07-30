extends Node

export(String, FILE) var prefix = ""
export var variant_count = 1
export var min_interval = 3.0
export var max_interval = 8.0
export var min_pitch = 0.7
export var max_pitch = 1.3

var _samples = []
var _remain = 0.0

onready var _player = get_node("AudioStreamPlayer3D")


func _ready():
	_player.pitch_scale = rand_range(min_pitch, max_pitch)

	for i in variant_count:
		var path = prefix
		if i != 0:
			path += str(i + 1)
		path += ".wav"
		var s = load(path)
		_samples.append(s)

	play_random()
	_remain = rand_range(min_interval, max_interval)


func _process(delta):
	_remain -= delta
	if _remain <= 0:
		_remain = rand_range(min_interval, max_interval)
		play_random()


func play_random():
	_player.stream = _samples[randi() % len(_samples)]
	_player.play()
