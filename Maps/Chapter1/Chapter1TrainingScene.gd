extends Stage

const FADING_DURATION = 0.5

onready var starting_dialogue_1 = Global.DIALOGUE.instance()
onready var starting_dialogue_2 = Global.DIALOGUE.instance()
onready var ending_dialogue_1   = Global.DIALOGUE.instance()

func _ready():
	starting_dialogue_1.add_answer("Inoue", "Asaka, bugün seninle final antrenmanını yapacağız.")
   
	starting_dialogue_2.add_answer("Inoue", "Senden bu parkuru bitirmeni istiyorum." 
	+ "Bu parkura birtakım tuzaklar ve hedefler ekledim.")
	starting_dialogue_2.add_answer("Inoue", "Yeteneklerini sınamak için harika bir fırsat! Dikkatli ol...")

	ending_dialogue_1.add_answer("Inoue", "Çok iyisin, Asaka! Önceki eğitimlerinden çok daha iyisin.")
	ending_dialogue_1.add_answer("Inoue", "Akşam oldu olacak, hadi eve dönelim.")

func start_stage() -> void:
	.start_stage()
	
	$Camera.enable(Global.player)
	$Camera.zoom = Vector2(1,1)
	$Camera.global_position = Global.player.global_position
	
	Global.player.can_move = false
	Global.player.can_jump = false

	#yield(get_tree().create_timer(1), "timeout")
	starting_dialogue_1.start()
	yield(starting_dialogue_1, "dialogue_completed")
	
	$AnimationPlayer.play("ShowParkour")

func end_stage() -> void:
	#Play animation...
	
	$Camera.disable()
	.end_stage()
	
func _on_FinishPoint_body_entered(body):
	if body.is_in_group("Player"):
		ending_dialogue_1.start()
		yield(ending_dialogue_1,"dialogue_completed")
		#end_stage()
		Global.stage_manager.change_stage("Map1")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ShowParkour":
		starting_dialogue_2.start()
		yield(starting_dialogue_2,"dialogue_completed")

		Global.player.can_move = true
		Global.player.can_jump = true
		$Tween.interpolate_property(Global.ui, "modulate", Color(1,1,1,0), Color(1,1,1,1), FADING_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "ShowParkour":
		$Tween.interpolate_property(Global.ui, "modulate", Color(1,1,1,1), Color(1,1,1,0), FADING_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
