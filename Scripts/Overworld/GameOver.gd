extends Node2D

@onready var gameover = $Gameover
@onready var soul = $Soul
@onready var writer : Writer = $Writer

var step : float = 0
var state : int = 0

var death_dialogue = [
	["{default:none}You can't give up now...",
		"{default:none}Stay [color=red]Determined[/color]."]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.display.fader.modulate.a = 0
	
	soul.global_position = Global.death_pos
	soul.play("normal")
	soul.modulate = Color.RED
	
	gameover.modulate.a = 0
	Global.sound_player.free_all_music()
	writer.dialogue_finished.connect(next_state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match state:
		0:
			if (step > 30):
				next_state()
		1:
			if (step == 0):
				soul.play("break")
				Global.sound_player.play_sfx("res://Sounds/SFX/soul_halve.wav")
			if (step > 50):
				next_state()
		2:
			if (step == 0):
				soul.self_modulate.a = 0
				Global.sound_player.play_sfx("res://Sounds/SFX/soul_shatter.wav")
				for i in 4:
					create_fragment(i,randf_range(-3,3),-randf_range(1,3),3)
			if (step > 50):
				next_state()
		3:
			if (step == 0):
				Global.sound_player.play_bgm("res://Sounds/BGM/mus_gameover.ogg")
			var alpha_factor : float = (step)/50.0
			gameover.modulate.a = alpha_factor
			if (step == 50):
				next_state()
		4:
			if (step == 0):
				writer.set_dialogue(death_dialogue[0],true)
				writer.next_string()
		5:
			Global.sound_player.now_playing["res://Sounds/BGM/mus_gameover.ogg"].volume_db -= 0.2
			if (step == 0):Global.display.fade(Color.BLACK,G_Display.TYPE.IN,2)
			if (step > 180):
				Global.sound_player.stop_all_music()
				get_tree().change_scene_to_file("res://Scenes/battle/BattleRoom.tscn")
				#GameFunc.Go_to_Overworld()
	step += 1

func next_state() -> void:
	state += 1
	step = -1

func create_fragment(_type:int,_xdir:float,_ydir:float,_fall_spd):
	var frag : SoulFragment = SoulFragment.new()
	frag.xspeed = _xdir
	frag.yspeed = _ydir
	frag.fall_spd = _fall_spd
	frag.type = _type
	soul.add_child(frag)
	return frag
