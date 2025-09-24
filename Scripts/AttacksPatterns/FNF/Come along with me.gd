extends AttackPattern

signal now

var las : float = 0

var idx : int = 0

var cart : Array[float] = [
	0.03,#Start
	
	0.1,0.36,0.43,0.69,0.76, # Click start
	
	1.03,##########
	
	11.29,12.3,12.4,12.5,#################
	13.51,13.56,13.71,13.76,13.81,##########Sans part
	14.8,14.9,15.0,#######################
	16.0,16.2,16.3,16.35,16.4,16.45,16.5,#
	
	17.5,17.6,17.75,17.89,####
	18.7,18.8,18.97,19.14,######Frisk part
	20.0,20.1,20.27,20.44,####
	21.3,21.4,21.55,21.65,####
	
	22.1,22.2,22.35,22.45,
	23.3,23.4,23.55,23.65,
	24.3,24.4,24.55,24.65,
	25.4,25.5,25.65,26.75,
	27.0,27.1,27.25,27.35,
	27.95,28.1,28.2,28.3,
	28.45,28.55,
	
	28.65,28.8,28.9,29.0,
	29.4,29.55,29.65,29.75,
	30.2,30.35,30.45,30.55,
	31.0,31.15,31.25,31.35,
	31.8,31.95,32.05,32.15,
	
	32.8,33.1,33.3,33.5,
	33.7,33.9,34.05,34.25,35.0,
	35.5,36.0,36.3,36.55,36.75,37.0,
	37.15,37.25,37.5,37.65,37.80,
	38.0
	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(480,50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if idx < cart.size():
		at_time(cart[idx])

func pre_attack():
	box.ypos = -40
	player.position = Vector2(320,280)
	box.radius = 20
	box.set_form("circle",1/10.0)
	#Global.sound_player.play_bgm(main.battle.Sound)

func main_attack():
	Global.sound_player.play_bgm(main.battle.Sound)
	player.modulate.a = 0
	player.shields.modulate.a = 0
	main.camera.can_beat = true
	main.camera.beat = 80*2
	main.camera.beat_amp = 1
	var creator = attacks_manager
	await now
	var vis = false
	for i in 6:
		Global.display.fader.modulate.a = 1
		vis = !vis
		Global.display.fader.visible = vis
		await now
	Global.display.fader.visible = true
	Global.display.fader.modulate.a = 0
	main.camera.beat_amp = 1.05
	var twe = create_tween()
	twe.tween_property(player,"modulate:a",1,1)
	twe.tween_property(player.shields,"modulate:a",1,1)
	await twe.finished
	await now
	player.lock = false
	await sans_part1(creator)
	await frisk_part1(creator)
	await now
	await sans_frisk_part1(creator)
	await sans_frisk_part2(creator)
	await sans_part2(creator)
	await now
	await frisk_part2(creator)

func frisk_part1(creator):
	creator.flow_arrow_p("left",6)
	await now
	creator.flow_arrow_p("left",6)
	await now
	creator.flow_arrow_p("up",6,1)
	await now
	creator.flow_arrow_p("up",6,2)
	creator.flow_arrow_p("right",6)
	await now # 2nd part
	creator.flow_arrow_p("down",6)
	await now
	creator.flow_arrow_p("down",6)
	await now
	creator.flow_arrow_p("up",6,1)
	await now
	creator.flow_arrow_p("down",6,2)
	await now # 3th part
	creator.flow_arrow_p("right",6)
	await now
	creator.flow_arrow_p("right",6)
	await now
	creator.flow_arrow_p("down",6,1)
	await now
	creator.flow_arrow_p("left",6,2)
	await now # 4th part
	creator.flow_arrow_p("up",6)
	await now
	creator.flow_arrow_p("up",6)
	await now
	creator.flow_arrow_p("right",6,1)
	await now
	creator.flow_arrow_p("up",6,2)

func sans_part1(creator):
	for i in 19:
		creator.flow_arrow_b(["right","up","left","down"].pick_random(),6.5)
		if i == 18:
			creator.flow_arrow_p("down",5,2)
		await now

func sans_frisk_part1(creator:AttackManager):
	creator.flow_arrow_p("left",6)
	await now
	creator.flow_arrow_p("left",6)
	await now
	creator.flow_arrow_p("up",6,1)
	await now
	creator.flow_arrow_p("up",6,2)
	creator.flow_arrow_b(["right","up","left","down"].pick_random(),7)
	await now #2nd part
	creator.flow_arrow_p("down",6)
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_p("down",6)
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_p("up",6,1)
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("down",6,2)
	creator.flow_arrow_b(["right","up","left","down"].pick_random(),7)
	await now # 3rd part
	creator.flow_arrow_p("right",6)
	creator.flow_arrow_b("left",7)
	await now
	creator.flow_arrow_p("right",6)
	creator.flow_arrow_b("left",7)
	await now
	creator.flow_arrow_p("down",6,1)
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_p("up",6,2)
	creator.flow_arrow_b(["right","up","left","down"].pick_random(),7)
	await now # 4th part
	creator.flow_arrow_p("up",6)
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("up",6)
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("right",6,1)
	creator.flow_arrow_b("left",7)
	await now
	creator.flow_arrow_p("left",6,2)
	creator.flow_arrow_b(["right","up","left","down"].pick_random(),7)
	await now #5th part
	creator.flow_arrow_p("up",6)
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("up",6)
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("right",6,1)
	creator.flow_arrow_b("left",7)
	await now
	creator.flow_arrow_p("down",6)
	creator.flow_arrow_b("up",7)
	await now # 6th part
	creator.flow_arrow_p("down",6)
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_p("up",6,1)
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("down",6,2)
	creator.flow_arrow_b(["right","up","left","down"].pick_random(),7)
	await now
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_b("left",7)
	await now
	creator.flow_arrow_p("left",6,2)
	creator.flow_arrow_b(["right","up","left","down"].pick_random(),7)

func sans_part2(creator:AttackManager):
	for i in 20:
		creator.flow_arrow_b(["right","up","left","down"].pick_random(),6.5)
		await now

func frisk_part2(creator:AttackManager):
	pass

func sans_frisk_part2(creator:AttackManager):
	await now
	creator.flow_arrow_b("right",7)
	await now
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_p("up",6,2)
	creator.flow_arrow_b("down",7)
	await now # part 2
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_b("left",7)
	await now
	creator.flow_arrow_b("right",7)
	await now
	creator.flow_arrow_p("right",6,2)
	creator.flow_arrow_b("down",7)
	await now # part 3
	creator.flow_arrow_b("right",7)
	await now
	creator.flow_arrow_b("up",7)
	await now
	creator.flow_arrow_b("down",7)
	await now
	creator.flow_arrow_p("left",6,2)
	creator.flow_arrow_b("down",7)

func attack_finished():
	pass

func at_time(_time:float):
	var snd = Global.sound_player.now_playing[main.battle.Sound]
	var t = (snd.get_playback_position()-las)/(_time-las)
	if t > 1:
		emit_signal("now")
		idx+=1
	las = snd.get_playback_position()
