tool
extends Sprite

export (bool) var visibility = false setget set_visibility

func active() -> void:
	_fade(Color(1,1,1,0), Color(1,1,1,1))
	
func deactive() -> void:
	_fade(Color(1,1,1,1), Color(1,1,1,0))
	
func _fade(initial_color, final_color) -> void:
	$Tween.interpolate_property(self, "modulate", initial_color, final_color, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()

func set_visibility(value:bool) -> void:
	visibility = value
	if visibility:
		active()
	else:
		deactive()
