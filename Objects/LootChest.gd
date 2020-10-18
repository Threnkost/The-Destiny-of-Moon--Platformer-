extends Area2D

export (int) var gold_amount = 0
export (bool) var available  = true

var player_in := false

func _input(event):
	if available and player_in and event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("UseDoor"):
			Global.player.wallet.currencies["Gold"].value += gold_amount
			queue_free()

func _on_LootChest_body_entered(body):
	player_in = true
	$KeyF.visible = true

func _on_LootChest_body_exited(body):
	player_in = false
	$KeyF.visible = false
