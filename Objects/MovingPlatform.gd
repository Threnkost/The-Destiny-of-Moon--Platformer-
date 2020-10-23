extends Node2D

const IDLE_DURATION = 1.0
const TRANS = Tween.TRANS_SINE
const EASE  = Tween.EASE_IN_OUT

onready var path = $PlatformPath
onready var platform = $Platform
onready var tween = $Tween

export (float, 1.0, 100.0) var speed = 1.0
export (bool) var return_to_initial_pos = true
export (bool) var loop = true
export (bool) var debug_mode = false

func _ready():
	path.visible = debug_mode
	tween.repeat = loop

func run():
	_init_tween()
	
func _init_tween() -> void:
	var duration = (path.points[1] - path.points[0]).length() / float(speed * 8)
	tween.interpolate_property(platform, "position", path.points[0], path.points[1], duration, TRANS, EASE, IDLE_DURATION)
	if return_to_initial_pos:
		tween.interpolate_property(platform, "position", path.points[1], path.points[0], duration, TRANS, EASE, 2*IDLE_DURATION + duration)
	tween.start()
