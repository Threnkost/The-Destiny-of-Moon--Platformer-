extends Entity

export (float) var speed = 300
export (int) var ai_react_time = 400

var player_in := false
var dir
var next_direction
var next_time

func _ready():
	direction = -1
	$Sprite.flip_h = true

func set_ai_direction(target_direction):
	if target_direction != next_direction:
		next_direction = target_direction
		next_time = OS.get_ticks_msec() + ai_react_time

func die():
	$AnimationPlayer.play("Death")

func damage(damager, damage):
	slide(Vector2(750,0), Vector2(0,0), Vector2(0.2,0), Vector2(damager.direction, 0))

	health_point -= damage
	if health_point <= 0:
		die()

func _physics_process(delta):
	$HealthBar.max_value = max_health_point
	$HealthBar.value     = health_point

	$Label.text = "%s/%s" % [health_point, max_health_point]

	_handle_sliding()

	if player_in:
		if Global.player.global_position.x < global_position.x - 60:
			set_ai_direction(-1)
		elif Global.player.global_position.x > global_position.x + 60:
			set_ai_direction(1)
		else:
			set_ai_direction(0)
		
		if OS.get_ticks_msec() > next_time:
			dir = next_direction
			velocity.x = dir * 300

	move_and_slide(velocity)

func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("Player"):
		player_in = false
