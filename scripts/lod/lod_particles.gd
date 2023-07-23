class_name LODParticles
extends GPUParticles3D

# If `false`, LOD won't update anymore. This can be used for performance comparison
# purposes.
@export var enable_lod := true

# The maximum particle emitting distance in units.
# Past this distance, particles will no longer emit.
@export_range(0.0, 1000.0, 0.1) var max_emit_distance := 50

# The rate at which LODs will be updated (in seconds). Lower values are more reactive
# but use more CPU, which is especially noticeable with large amounts of LOD-enabled nodes.
# Set this accordingly depending on your camera movement speed.
# The default value should suit most projects already.
# Note: Slow cameras don't need to have LOD-enabled objects update their status often.
# This can overridden by setting the project setting `lod/_refresh_rate`.
var _refresh_rate := 0.25

# The internal refresh timer.
var _timer := 0.0


func _ready() -> void:
	if ProjectSettings.has_setting("lod/_refresh_rate"):
		_refresh_rate = ProjectSettings.get_setting("lod/_refresh_rate")

	# Add random jitter to the timer to ensure LODs don't all swap at the same time.
	randomize()
	_timer += randf_range(0, _refresh_rate)


# Despite LOD not being related to physics, we chose to run in `_physics_process()`
# to minimize the amount of method calls per second (and therefore decrease CPU usage).
func _physics_process(delta: float) -> void:
	if not enable_lod:
		return

	# We need a camera to do the rest.
	var camera := get_viewport().get_camera_3d() as Camera3D
	if camera == null:
		return

	if _timer <= _refresh_rate:
		_timer += delta
		return

	_timer = 0.0

	var distance := camera.global_transform.origin.distance_to(global_transform.origin) + lod_bias
	emitting = distance < max_emit_distance
