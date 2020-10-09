extends Node

export (NodePath) var target_sprite_path

onready var target_sprite:Sprite

var temp_sprite:Sprite
var frequency := 0

func _ready():
	target_sprite = get_node(target_sprite_path)

func start(duration = 5, frequency := 0.2) -> void:
	self.frequency = frequency
  
	$Frequency.wait_time = frequency
	$Duration.wait_time = duration
	$Duration.start()
	$Frequency.start()

	_create()

func _create() -> void:
	temp_sprite = Sprite.new()
	Global.current_stage.add_child(temp_sprite)

	temp_sprite.texture = target_sprite.texture
	temp_sprite.global_position = target_sprite.owner.global_position
	temp_sprite.z_index = target_sprite.z_index -1
	$Tween.interpolate_property(temp_sprite, "modulate", Color(1,1,1,0.85), Color(1,1,1,0), frequency, $Tween.TRANS_LINEAR, $Tween.EASE_OUT)
	$Tween.start()
	
func _on_Duration_timeout():
	temp_sprite.queue_free()

func _on_Frequency_timeout():
	temp_sprite.queue_free()
	_create()
