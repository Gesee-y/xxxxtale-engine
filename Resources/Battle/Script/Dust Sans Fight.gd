extends BattleContinuity

signal time_as_come

var phase = 1
var last_pos : float = 0
var start = false

var idx = 0
var cart = [5.1,8.4,12.3,14.3,16.7]
var sans : Enemy

# Called when the node enters the scene tree for the first time.
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
	
	Global.damage_multiplier = 1.5
	sans = enemy.enemies[0]
	Global.players[0].attack = 99
	Global.players[0].hp = 48
	Global.players[0].LV = 8
	Global.players[0].max_hp = 48
	Global.players[0].weapon_name = "T.Knife"
	Global.players[0].weapon = GameFunc.initialize_weapon("T.Knife")
	main.event_manager.set_target()
	
	main.player.shield_active = true
	main.player.shield_cost = 3

func Intro():
	match phase:
		1:
			phase1_intro()

func phase1_intro():
	if Flags.Intro_seen:
		Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,2)
		Global.current_phase = Global.phase.ENEMY_ATTACK
		main.menu_no = [-3,0]
		main.event_manager.turn = -1
		attacks.pre_attack()
		await get_tree().create_timer(1).timeout
		enemy.enemies[0].writer.set_dialogue(["{sans:normal}Welcome back, pal."],false)
		enemy.enemies[0].writer.next_string()
		Global.display.fader.visible = true
		await enemy.enemies[0].writer.dialogue_finished
		
		talk_click(["{sans:red_eye_nerfed}Ready ?"])
		await enemy.enemies[0].writer.dialogue_finished
		attacks.start_attack()
	else:
		Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,3)
		main.menu_no = [-3,0]
		main.event_manager.turn = -1
		attacks.pre_attack()
		var dialogue = ["{sans:normal}It's a quiet night today.",
				"{sans:eye_closed}Birds are fleeing.",
				"{sans:white_eye_1}Dust has filled the air.",
				"{sans:eye_closed}On a night like this...",
				"{sans:normal}You and me...",
				]
		enemy.enemies[0].writer.set_dialogue(dialogue,false,false,true)
		await get_tree().create_timer(1).timeout
		enemy.enemies[0].writer.next_string()
		
		await get_tree().create_timer(2.5).timeout
		
		Global.current_phase = Global.phase.ENEMY_ATTACK
		Global.sound_player.play_bgm("res://Sounds/BGM/dust_intro.ogg")
		await get_tree().create_timer(0.5).timeout
		start = true
		
		while idx < cart.size()-1:
			if idx < cart.size()-2:enemy.enemies[0].writer.next_string()
			await time_as_come
		
		enemy.enemies[0].writer.next_string()
		talk_click(["{sans:red_eye_nerfed}are going to have a [color=red]Mad time[/color]!"])
		await enemy.enemies[0].writer.dialogue_finished
		
		Flags.Intro_seen = true
		attacks.start_attack()
	

func _process(_delta):
	if start && !Flags.Intro_seen && idx < cart.size():
		if time_as("res://Sounds/BGM/dust_intro.ogg",cart[idx]) : idx+=1
		

func talk_click(_dial):
	Global.display.click(0.5)
	await get_tree().create_timer(0.5).timeout
	enemy.enemies[0].writer.set_dialogue(_dial,false)
	enemy.enemies[0].writer.next_string()

func time_as(mus,_time:float):
	var sound : AudioStreamPlayer = Global.sound_player.now_playing[mus]
	var actual_pos = sound.get_playback_position()
	var t = (actual_pos-last_pos)/(_time-last_pos)
	if t>=1:
		emit_signal("time_as_come")
		return true
	last_pos = actual_pos
	return false


func battle_status(_turn) -> String:
	return "Our deadmatch has finally begun [color=red]=)[/color]."
