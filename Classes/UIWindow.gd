extends Control
class_name UIWindow

func open() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func is_openable() -> bool:
	return Global.current_ui_window == null
