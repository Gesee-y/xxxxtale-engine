extends BattleContinuity

var intr = 0
var phase = 1

func _ready():
	
	Global.Items = [
	"ButtsPie",
	"L.Hero",
	"Starfair",
	"L.Hero",
	"F.Steak",
	"Ketchup",
	"Gold.Tea",
	"Ban.Sp",
]
	Global.initialize_items()
	
	main.back_layer.visible = true
	if Global.players[0].Name == "Frisk" : Flags.HardMode = true
	super._ready()
	
	main.player.inside = true
	Global.players[0].attack = 9999
	Global.players[0].kr = true
	Global.players[0].hp = 92
	Global.players[0].LV = 19
	Global.players[0].max_hp = 92
	Global.players[0].weapon_name = "R.Knife"
	Global.players[0].weapon = GameFunc.initialize_weapon("R.Knife")
	main.event_manager.set_target()
	enemy.enemies[0].sprite.eye_closed()

func Intro():
	match phase:
		1:
			phase1_intro()
		2:
			phase2_intro()

func phase1_intro():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,1)
	main.menu_no = [-3,0]
	main.event_manager.turn = -1
	if Flags.HardMode : main.attack_manager.pattern = ["res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack0.gd"]
	attacks.pre_attack()
	Global.current_phase = Global.phase.ENEMY_ATTACK
	await get_tree().create_timer(1).timeout
	var dialogue = ["It's a cold night outside.",
			"Flowers are fading.",
			"Stars are going out.",
			"And in the middle of this darkness."
			]
	enemy.enemies[0].writer.set_dialogue(dialogue,false)
	enemy.enemies[0].writer.next_string()
	await enemy.enemies[0].writer.dialogue_finished
	talk_click()
	await enemy.enemies[0].writer.dialogue_finished
	attacks.start_attack()

func phase2_intro():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,1)
	main.menu_no = [-3,0]
	main.event_manager.turn = -1
	Global.current_phase = Global.phase.ENEMY_ATTACK
	
	if Flags.HardMode : attacks.pattern = ["res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 2 HM/attack0.gd"]
	else : attacks.pattern = ["res://Scripts/AttacksPatterns/FS!Sans/Phase 2/attack0.gd"]
	attacks.pre_attack()
	attacks.start_attack()
	main.event_manager.turn += 1

func Intro_phase2():
	phase = 2
	var sans = enemy.enemies[0]
	sans.sprite.eye_closed()
	if main.event_manager.turn > 1 : main.event_manager.turn = -1
	
	var phase2_dialogue : Array[Array]= [
		["I know about your power.","{sans:black_eye_2}[color=red]Determination."],
		
		["{sans:eye_closed}At first I thought that you would finally end the monster's suffering.",
				"{sans:normal}It felt so good to feel hope again."],
		
		["{sans:eye_closed}But it turn out your are same as him.",
				"{sans:black_eye_2}Your perveted sense of justice drive you too far."],
		
		["{sans:black_eye_1}What are you trying to achieve ?",
				"Save humanity ?",
				"Find happiness ?",
				"{sans:red_eye_look_right}Or you just want [color=red]power[/color] ?"],
		
		["{sans:black_eye_1}But that is enough ! You gotta have to know when to stop...",
				"{sans:red_eye_nerfed}And it's now."],
		
		["{sans:eye_closed}A persistent one, huh?",
				"It's a warning if you don't stop now",
				"{sans:black_eye_2}You will really not like what will come next."],
		
		["{sans:normal}Stubborn... as always.",
				"{sans:eye_closed}Okay, prepare yourself.",
				"{sans:red_eye_nerfed}'cause your greed will end there."]
	]
	
	var dialogue = ["Look kid.","There is no reasoning with you.",
			"Let's just do it the hard way."]
	sans.writer.set_dialogue(dialogue)
	sans.writer.next_string()
	
	sans.Dialogue = phase2_dialogue
	await sans.writer.dialogue_finished

func _process(delta):
	super._process(delta)
	turn = main.event_manager.turn

func expression():
	var idx = enemy.enemies[0].writer.current_string
	var head = enemy.enemies[0].sprite
	var expr : Array[Callable] = [head.normal,
		head.black_eye_1,
		head.black_eye_2,
		head.black_eye_3,
		head.eye_closed,
		head.look_right,
		head.red_eye_nerfed,
		head.red_eye_look_right,
		head.black_eye_blood,
		head.eye_closed_blood,
		head.normal_blood,
		head.look_right_blood]
	if intr == 0:
		var expres = [4,4,4,4]
		expr[expres[idx]].call()
	if intr == 1:
		var expres = [6,6]
		expr[expres[idx]].call()
	if intr == 2:
		var expres = [0,0]
		expr[expres[idx]].call()

func battle_status(_turn:int) -> String:
	match phase:
		1:
			match _turn:
				0:return "You feel like won't have good time."
				2:return "There is still a star shining."
				1:return "Cold and dark."
				7:return "It's the end."
			if _turn > 2 and _turn < 7:
				return ["You feel your sins weightning on your neck.",
						"You feel your sins crawling on your back.",
						"You see your sins flashing in your mind.",
						"The emptyness fills your heart."].pick_random()
		2:
			match _turn:
				0:return "The real fight just begun."
				1:return "Seem like a turning point."
				2:return "Keep going."
				3:return "Why is there some tears in your eyes ?"
				4:return "Sans's movements are slower"
				5:return "Sans seems to have something on his mind."
				6:return "Hope your are prepared."
				7:return "End this!"
	
	return "Despair fills the room."

func talk_click():
	Global.display.click(0.5)
	await get_tree().create_timer(0.25).timeout
	enemy.enemies[0].sprite.red_eye_nerfed()
	await get_tree().create_timer(0.25).timeout
	var _dial = ["I will end you."]
	enemy.enemies[0].writer.set_dialogue(_dial,false)
	enemy.enemies[0].writer.next_string()
