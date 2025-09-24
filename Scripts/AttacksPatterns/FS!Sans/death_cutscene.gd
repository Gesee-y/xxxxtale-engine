extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var sans = main.enemy_manager.enemies[0]
	if sans.writer.current_string == 0:
		sans.head.frame = 8
	if sans.writer.current_string == 1:
		sans.head.frame = 11
	if sans.writer.current_string == 2:
		sans.head.frame = 9
	

func pre_attack():
	pass

func main_attack():
	var sans = main.enemy_manager.enemies[0]
	Global.current_phase = Global.phase.NULL
	
	sans.can_wave = false
	await get_tree().create_timer(2).timeout
	sans.writer.end_writer()
	var dial = [
		"So that is how it is, huh?",
		"He...,at least it's finish.",
		"I am going to grilby's."
	]
	sans.writer.set_dialogue(dial)
	sans.writer.next_string()
	await sans.writer.dialogue_finished
	var tween = create_tween()
	tween.tween_property(sans,"position:x",-30,1.5).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sans,"position:x",10,1).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sans,"position:x",-50,5).set_trans(Tween.TRANS_SINE)
	await tween.finished
	sans.writer.set_dialogue(["{S1}Paps, Do you want something?"])
	sans.writer.next_string()
	await sans.writer.dialogue_finished
	Global.sound_player.play_sfx("res://Sounds/SFX/Vaporise.wav")
	
	Global.display.fade()
	await get_tree().create_timer(4).timeout
	GameFunc.Go_to_Overworld(main.battle.just_a_fight,main.battle.path_to_credit)

func attack_finished():
	pass

