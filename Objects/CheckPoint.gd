extends Area2D

var taken := false

func _ready():
	$Particles.emitting = false

func _on_CheckPoint_body_entered(body):
	if body.is_in_group("Player") and not taken and Global.current_stage.name == owner.name:
		taken = true
		$Particles.emitting = true
		Global.last_check_point["position"] = global_position
		Global.last_check_point["map_name"] = owner.name
