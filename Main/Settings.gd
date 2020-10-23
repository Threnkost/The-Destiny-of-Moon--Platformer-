extends Node

onready var _settings_path = "Settings.json"

var settings := {
	"show_fps":false,
	"fullscreen_mode":false,
	"vsync_enabled":true,
	"target_fps":60,
	"volume":1.0
}

func _ready():
	load_settings()

func set_show_fps_mode(value:bool):
	settings["show_fps"] = value
	save_settings()

func set_fullscreen_mode(value:bool):
	settings["fullscreen_mode"] = value
	OS.window_fullscreen = value
	save_settings()

func set_vsync_mode(value:bool):
	settings["vsync_enabled"] = value
	OS.vsync_enabled = value
	save_settings()

func set_target_fps(target_fps:int):
	settings["target_fps"] = target_fps
	Engine.target_fps = target_fps
	save_settings()

func set_volume(volume) -> void:
	settings["volume"] = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	save_settings()

func save_settings() -> void:
	var text_to_save = to_json(settings)
	var file = File.new()
	var data_to_write = to_json(settings)
	file.open(_settings_path, File.WRITE)
	file.store_line(data_to_write)
	file.close()

func load_settings() -> void:
	var file_to_read = File.new()
	if !file_to_read.file_exists(_settings_path):
		save_settings()
	file_to_read.open(_settings_path, File.READ)
	settings = parse_json(file_to_read.get_as_text())
	file_to_read.close()

	set_show_fps_mode(settings["show_fps"])
	set_fullscreen_mode(settings["fullscreen_mode"])
	set_vsync_mode(settings["vsync_enabled"])
	set_target_fps(settings["target_fps"])
	set_volume(settings["volume"])
