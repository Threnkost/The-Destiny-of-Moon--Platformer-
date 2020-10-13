extends Entity

export (float) var speed = 300
export (float) var attack_range = 1.0
export (int) var ai_react_time = 400 #AI

#STATE MACHINE
enum ai_states {
	IDLE,
	FOLLOWING_PLAYER,
	ATTACKING,
	WALKING
}

onready var anim_tree

#AI
var player_in          := false
var ai_next_direction  := 0
var ai_next_react_time := 0

export (ai_states) var current_state = ai_states.IDLE

#COMBAT MECHANICS
export (bool) var can_attack = false

func stun(duration := 0.5) -> void:
	bad_state = bad_states.STUNNED
	$CombatMechanics/StunTimer.wait_time = duration
	$CombatMechanics/StunTimer.start()

func _ready() -> void:
	anim_tree = $AnimationTree.get("parameters/playback")

	direction = -1
	$HealthBar.modulate = Color(1,1,1,0)

func die() -> void:
	.die()
	$AnimationPlayer.play("Death")

func set_next_direction(target_direction) -> void:
	if ai_next_direction != target_direction:
		ai_next_direction = target_direction
		ai_next_react_time = OS.get_ticks_msec() + ai_react_time

func damage(damager, damage, push_scale:=1) -> void:
	slide(Vector2(300*push_scale,0), Vector2(0,0), Vector2(0.2,0), Vector2(damager.direction, 0))

	$HealthBar.modulate = Color(1,1,1,1)
	$Timers/HealthBarDelay.start()

	stun(1)

	health_point -= damage
	if health_point <= 0:
		die()

func _physics_process(delta) -> void:
	$HealthBar.max_value = max_health_point
	$HealthBar.value     = health_point
	$HealthBar/HealthBarValue.text = "%s/%s" % [health_point, max_health_point]

	velocity.y += GRAVITY
	if velocity.y >= MAX_GRAVITY:
		velocity.y = MAX_GRAVITY
	
	if is_on_floor():
		velocity.y = 0
	
	_handle_sliding()
	_handle_states(delta)
	
	velocity.y = move_and_slide_with_snap(get_total_velocity(), 8.0*Vector2.DOWN, 
		Vector2.UP, true, 4, deg2rad(45.1)).y

func _handle_states(delta) -> void:
	if bad_state == bad_states.STUNNED:
		return
	match current_state:
		ai_states.IDLE:
			anim_tree.travel("Idle")
			velocity = Vector2.ZERO
		ai_states.WALKING:
			pass
		ai_states.ATTACKING:
			anim_tree.travel("Attack")
			velocity = Vector2.ZERO
		ai_states.FOLLOWING_PLAYER:
			_follow_player()

func _follow_player() -> void:
	if true: #player_in:
		if position.x < Global.player.position.x - attack_range: #Move to right
			set_next_direction(1)
		elif position.x > Global.player.position.x + attack_range: #Move to left
			set_next_direction(-1)
		else:
			set_next_direction(0)
			if can_attack:
				current_state = ai_states.ATTACKING

		if OS.get_ticks_msec() > ai_next_react_time:
			direction = ai_next_direction
			velocity.x = speed * direction

func _attack() -> void:
	if Global.player.is_damagable():
		Global.player.damage(self, 5)

func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("Player"):
		current_state = ai_states.FOLLOWING_PLAYER

func _on_HealthBarDelay_timeout():
	$Tween.interpolate_property($HealthBar, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_AttackCooldown_timeout():
	can_attack = true

func _on_StunTimer_timeout():
	bad_state = bad_states.NORMAL
