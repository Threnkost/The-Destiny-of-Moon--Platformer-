extends Camera2D

const TRANS = Tween.EASE_IN_OUT
const EASE  = Tween.TRANS_SINE

export (bool) var follow_player = true

var amplitude = 0
var priority  = 0

var target = null
var pos_offset := Vector2.ZERO

func enable(target):
	self.target = target
	Global.player.active_camera = self
	current = true
	
func disable():
	target  = null
	current = false
	Global.player.active_camera = null

func _physics_process(delta):
	if target and follow_player:
		global_position = target.global_position + pos_offset

func shake(duration := 0.2, frequency = 15, amplitude = 16) -> void:
	if self.priority >= priority:
		self.priority  = priority
		self.amplitude = amplitude

		$Duration.wait_time  = duration
		$Frequency.wait_time = 1 / float(frequency)

		$Duration.start()
		$Frequency.start()

func _create_shake() -> void:
	randomize()
	var x = rand_range(-amplitude, amplitude)
	var y = rand_range(-amplitude, amplitude)

	$Tween.interpolate_property(self, "offset", Vector2.ZERO, Vector2(x,y), $Frequency.wait_time, TRANS, EASE)
	$Tween.start()

func _reset() -> void:
	$Tween.interpolate_property(self, "offset", offset, Vector2.ZERO, $Frequency.wait_time, TRANS, EASE)
	$Tween.start()

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()

func _on_Frequency_timeout():
	_create_shake()
