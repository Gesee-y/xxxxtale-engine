extends Node
class_name EventsManager

signal event_done

var main : BattleManager
var enemies_manager : EnemyManager
var attack_manager : AttackManager
var dialogue_manager : DialogueManager = DialogueManager.new()
var box : Box
var text:Writer
var events : Array[Array] = []
var items_manager : DataManager = DataManager.new()
var attackers = []
var targets = []
var target_field
var regular_talk : bool = true
var talker : Array[int] = []
var turn : int = 0
var attack_type : String = "attack"

func _ready():
	connect("event_done",event)
	dialogue_manager.enemy_manager = enemies_manager
	dialogue_manager.event_manager = self
	dialogue_manager.main = main
	add_child(dialogue_manager)
	if main.battle.dialogue_file != "" : 
		var all = dialogue_manager.get_speech_arrays(main.battle.dialogue_file)
		dialogue_manager.overall_dialogue = all[0]
		dialogue_manager.overall_index = all[1]

func event():
	match Global.current_phase:
		Global.phase.PLAYER_EVENTS:
			player_events()
			main.player.visible = false
		Global.phase.ENEMY_TARGET:
			enemy_target()
			main.player.visible = true
		Global.phase.ENEMY_EVENT:
			enemy_event()
		Global.phase.ENEMY_ATTACK:
			enemy_attack()

func player_events():
	for i in events.size():
		match events[0][0]:
			"defend":
				attack_type = "attack"
			"act":
				enemies_manager.Acting.emit(events[0][2],events[0][3])
				attack_type = "heal"
				await events[0][2].act_finished
			"magic":
				attack_type = "attack"
			"mercy":
				attack_type = "heal"
				if events[0][2]==0:
					enemies_manager.spare_enemy()
				else:
					var flee = AnimatedSprite2D.new()
					flee.sprite_frames = load("res://Resources/Flee.tres")
					box.mask.add_child(flee)
					flee.global_position = text.global_position+Vector2(40,15)
					create_tween().tween_property(flee,"position:x",-60,2)
					flee.play("default")
					text.set_dialogue(["Escape..."],false,false,true)
					text.next_string()
					text.position.x+=50
					main.battle_finish = true
					await get_tree().create_timer(0.5).timeout
					var tween = Global.display.fade(Color.BLACK,G_Display.TYPE.IN,2)
					tween.finished.connect(Global.Go_to_Overworld)
					Global.current_phase = Global.phase.END
				await get_tree().create_timer(0.05).timeout
			"item":
				GameFunc.UseItem(events[0][-1],events[0][1],events[0][2],dialogue_manager,text)
				attack_type = "heal"
				await text.dialogue_finished
			"fight":
				attackers.append(events[0][1])
				targets.append(events[0][2])
				if events.size() == 1:
					target_field = await GameFunc.CreateTargetBar(attackers,targets,box,self)
					await target_field.finish
				attack_type = "attack"
				if main.battle.attack_to_continue && target_field.bar_hitted < 1 : attack_type = "heal"
				
		if events[0][0] != "item":
			talker.append(events[0][2])
		events.pop_front()
	if dialogue_manager.dialogue_started : await dialogue_manager.Dialogue_end
	if events.size() <= 0 and !(Global.current_phase == Global.phase.END):
		Global.current_phase = Global.phase.ENEMY_TARGET
	emit_signal("event_done")

func enemy_target():
	if enemies_manager.remaining_enemy().size() == 0:
		Global.current_phase = Global.phase.END
		main.player.get_child(0).visible = false
		text.end_writer()
		main.menu_no = [-3,0]
		if target_field != null:
			var tween = create_tween()
			tween.tween_property(target_field,"scale:x",0,.2).set_trans(Tween.TRANS_SINE)
			tween.finished.connect(Callable(target_field,"queue_free"))
			tween.finished.connect(finish_battle)
	else:
		set_target()
		var bar_hitted = 0
		if target_field != null : bar_hitted = target_field.bar_hitted
		
		if (main.battle.attack_to_continue && bar_hitted < 1): attack_type = "Heal"
		
		if !main.battle.attack_to_continue : attack_type = "attack"
		
		attack_manager.type = attack_type
		var _dialogue : Array = []
		var cond2 = main.battle.attack_to_continue && (bar_hitted>0)
		
		if ((!main.battle.attack_to_continue) or (cond2)) && !dialogue_manager.advanced_mode and talker.size()>0:
			
			var _enemy = enemies_manager.enemies[talker[0]]
			var idx = turn if !_enemy.random_talk else randi_range(0,_enemy.Dialogue.size()-1)
			var dialogue_size = _enemy.Dialogue.size() if main.battle.dialogue_file == "" else dialogue_manager.overall_dialogue.size()
			
			if idx < dialogue_size:
				_dialogue = [_enemy.Dialogue[idx]] if main.battle.dialogue_file == "" else dialogue_manager.overall_dialogue[idx]
				var talkers = talker if main.battle.dialogue_file == "" else dialogue_manager.overall_index[idx]
				
				dialogue_manager.set_dialogue(_dialogue,talkers)
				dialogue_manager.Start_dialogue()
		
		if target_field != null:
			var tween = create_tween()
			tween.tween_property(target_field,"scale:x",0,.2).set_trans(Tween.TRANS_SINE)
			tween.finished.connect(Callable(target_field,"queue_free"))
		
		
		Global.sound_player.play_sfx("res://Sounds/SFX/bell.ogg")
		await attack_manager.pre_attack()
		Global.current_phase = Global.phase.ENEMY_EVENT
		if dialogue_manager.dialogue_started : await dialogue_manager.Dialogue_end
		emit_signal("event_done")

func enemy_event():
	Global.current_phase = Global.phase.ENEMY_ATTACK
	emit_signal("event_done")

func enemy_attack():
	if !attack_manager.attack_start:
		attack_manager.start_attack()
		if !main.battle.attack_to_continue :turn += 1
		else :
			if attack_type == "attack":
				turn+=1
		emit_signal("event_done")

func set_target():
	var target_num = randi_range(1,Global.players.size())
	Global.enemies_target = []
	for i in target_num:
		var targ = Global.players.pick_random()
		while Global.enemies_target.has(targ):
			targ = Global.players.pick_random()
		Global.enemies_target.append(targ)

func reset_event():
	Global.current_phase = Global.phase.PLAYER
	attackers = []
	targets = []
	talker = []
	for enemy in enemies_manager.enemies:
		enemy.ReadyForBattle = false
	main.player_active = 0
	main.player_events = []
	main.reset_text_table()
	main.menu_timer = 0.0
	main.text.dialogue = []
	main.player.visible = true
	main.menu_no = [-1,0]
	main.menu_coord = [0,0]
	attack_manager.attack_start = false
	main.initialized = false

func finish_battle():
	Global.sound_player.stop_all_music()
	text.end_writer()
	#var _exp = enemies_manager.total_exp
	#var _gold = enemies_manager.total_gold
	#main.button_controller.selected = -1
	#text.set_dialogue(["You Won!!~You earned %d EXP and %d Gold."%[_exp,_gold]],true,true,true)
	#text.next_string()

