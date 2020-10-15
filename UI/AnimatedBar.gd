extends TextureProgress

export (float) var duration = 0.5

#const DURATION = 0.5
const TRANS = Tween.TRANS_CUBIC
const EASE  = Tween.EASE_OUT

var true_max_value : float = 0.0 setget set_true_max_value
var true_value : float = 0.0 setget set_true_value

func _ready():
	true_max_value = max_value
	true_value = value

func set_true_value(new_value) -> void:
	true_value = new_value
	$Tween.interpolate_property(self, "value", value, true_value, duration, TRANS, EASE)
	$Tween.start()

func set_true_max_value(new_value) -> void:
	true_max_value = new_value
	$Tween.interpolate_property(self, "max_value", max_value, true_max_value, duration, TRANS, EASE)
	$Tween.start()
