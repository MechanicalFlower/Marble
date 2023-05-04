extends Node

const MYMODNAME_MOD_DIR = "florianvazelle-cheatcodes/"
const MYMODNAME_LOG = "florianvazelle-cheatcodes"


func _init(loader = ModLoader):
	ModLoaderUtils.log_info("Init", MYMODNAME_LOG)
	var dir = loader.UNPACKED_DIR + MYMODNAME_MOD_DIR
	var ext_dir = dir + "extensions/"

	# Add extensions
	loader.install_script_extension(ext_dir + "main.gd")


func _ready():
	ModLoaderUtils.log_info("Done", MYMODNAME_LOG)
