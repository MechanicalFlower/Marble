tool

extends EditorPlugin

# Path to the version script file
const VERSION_SCRIPT_PATH = "res://scripts/version.gd"

var exporter: AEVExporter


func fetch_version() -> String:
	# Version is number of commits. Requires git installed
	# and project inside git repository with at least 1 commit.
	var output := []
	var exit_code := OS.execute("git", ["rev-parse", "--short", "HEAD"], true, output)
	if output.empty() or output[0].empty():
		push_error("Failed to fetch version. Make sure you have git installed and project is inside valid git directory.")
	else:
		return output[0].trim_suffix("\n")
	return ""

func _enter_tree() -> void:
	exporter = AEVExporter.new()
	exporter.plugin = self
	add_export_plugin(exporter)

	if not File.new().file_exists(VERSION_SCRIPT_PATH):
		exporter.store_version(fetch_version())

func _exit_tree() -> void:
	remove_export_plugin(exporter)

class AEVExporter extends EditorExportPlugin:
	var plugin

	func _export_begin(_features: PoolStringArray, _is_debug: bool, _path: String, _flags: int) -> void:
		var version: String = plugin.fetch_version()
		store_version(version)

	func store_version(version: String) -> void:
		var script := GDScript.new()
		script.source_code = str("extends Reference\n\nconst VERSION := \"", version, "\"\n")
		if ResourceSaver.save(VERSION_SCRIPT_PATH, script) != OK:
			push_error("Failed to save version file. Make sure the path is valid.")
