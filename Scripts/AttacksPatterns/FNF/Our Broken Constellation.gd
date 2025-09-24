extends AttackPattern

signal now
var las : float = 0
var idx : int = 0

var cart : PackedFloat32Array = [
	# First part
	20.4 , 20.7 , 20.95 , 21.3 , 21.65 , 21.85 , 22.0 ,
	22.2 , 22.4 , 22.6 , 23 , 23.4 , 23.7 , 24 , 24.5
]

func _ready():
	box_pre = Vector2(480,50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if idx < cart.size():
		at_time(cart[idx]-1)

func pre_attack():
	player.position = Vector2(320,240)

func main_attack():
	Global.sound_player.play_bgm(main.battle.Sound,1.1)
	player.modulate.a = 1
	player.shields.modulate.a = 1
	main.camera.can_beat = true
	main.camera.beat = 121
	main.camera.beat_amp = 1.05
	main.player.set_mode(PlayerSoul.MODE.GREEN,"",false,1)
	await now
	
	# The game Start here
	var spd = 5
	var arrows_dir = [
		["left",0],["right",0],["left",0],["up",1],["down",1],["up",1],
		["right",2],["up",2],["down",0],["down",0],["down",0]
	]
	
	for i in arrows_dir.size():
		arrow(arrows_dir[i][0],spd,arrows_dir[i][1])
		await now
	

func attack_finished():
	pass

func at_time(_time:float):
	var snd = Global.sound_player.now_playing[main.battle.Sound]
	var t = (snd.get_playback_position()-las)/(_time-las)
	if t > 1:
		emit_signal("now")
		idx += 1
	las = snd.get_playback_position()
