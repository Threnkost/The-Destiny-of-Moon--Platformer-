extends Stage


var collision_mask_of_tilemap  := 1
var collision_layer_of_tilemap := 1

func _ready():
	collision_mask_of_tilemap = $Background/Walls.collision_mask
	collision_layer_of_tilemap = $Background/Walls.collision_layer

	.disable_tilemap_collision($Background/Walls)

#func _on_Stage_changed(next_stage, previous_stage):
##	if previous_stage == self:
##		end_stage()	
##	if next_stage == self:
##		start_stage()

func start_stage():
	visible = true
	
	$Camera.enable(Global.player)
	.add_player($StartPosition.position)
	.enable_tilemap_collision($Background/Walls, collision_layer_of_tilemap, collision_mask_of_tilemap)

func end_stage():
	visible = false	
	
	$Camera.disable()
	.remove_player()
	.disable_tilemap_collision($Background/Walls)
