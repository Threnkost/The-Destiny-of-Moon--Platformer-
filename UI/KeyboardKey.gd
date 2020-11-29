extends Sprite

export (float) var duration = 0.5

func _ready():
	modulate = Color(1,1,1,0)

func show() -> void:
	_apply_interpolate(modulate, Color(1,1,1,1))

func hide() -> void:
	_apply_interpolate(modulate, Color(1,1,1,0))
	
func _apply_interpolate(initialize_color = Color(1,1,1,0), final_color = Color(1,1,1,1)) -> void:
	$Tween.interpolate_property(self, "modulate", initialize_color, final_color, duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()	
