extends UIWindow

func open() -> void:
	if is_openable():
		.open()
		visible = true
		Global.current_ui_window = self
		
	
func close() -> void:
	.close()
	visible = false
	Global.current_ui_window = null
	

func _ready() -> void:
	$Panel/Buttons/Fullscreen.pressed = Settings.settings["fullscreen_mode"]
	$Panel/Buttons/ShowFPS.pressed    = Settings.settings["show_fps"]
	$Panel/Buttons/Vsync.pressed      = Settings.settings["vsync_enabled"]
	$Panel/Buttons/TargetFps.value    = Settings.settings["target_fps"]
	$Panel/Volume.value               = Settings.settings["volume"]

func _on_Fullscreen_pressed():
	Settings.set_fullscreen_mode($Panel/Buttons/Fullscreen.pressed)

func _on_ShowFPS_pressed():
	Settings.set_show_fps_mode($Panel/Buttons/ShowFPS.pressed)

func _on_CheckBox_pressed():
	Settings.set_vsync_mode($Panel/Buttons/Vsync.pressed)

func _on_TargetFps_value_changed(value):
	Settings.set_target_fps(value)

func _on_Volume_value_changed(value):
	Settings.set_volume(value)
