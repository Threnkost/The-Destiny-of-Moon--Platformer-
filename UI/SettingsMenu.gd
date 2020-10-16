extends Control

func open() -> void:
	visible = true

func hide() -> void:
	visible = false

func _ready() -> void:
	$Panel/Buttons/Fullscreen.pressed = Settings.settings["fullscreen_mode"]
	$Panel/Buttons/ShowFPS.pressed    = Settings.settings["show_fps"]
	$Panel/Buttons/Vsync.pressed      = Settings.settings["vsync_enabled"]
	$Panel/Buttons/TargetFps.value    = Settings.settings["target_fps"]

func _on_Fullscreen_pressed():
	Settings.set_fullscreen_mode($Panel/Buttons/Fullscreen.pressed)

func _on_ShowFPS_pressed():
	Settings.set_show_fps_mode($Panel/Buttons/ShowFPS.pressed)

func _on_CheckBox_pressed():
	Settings.set_vsync_mode($Panel/Buttons/Vsync.pressed)

func _on_TargetFps_value_changed(value):
	Settings.set_target_fps(value)
