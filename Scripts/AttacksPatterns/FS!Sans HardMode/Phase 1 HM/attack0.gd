extends AttackPattern

var a : Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

func main_attack():
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	var bon1 = bone(box.corner_bottom-Vector2(0,20),0,180,Vector2(25,0),0,0,true)
	var bon2 = bone(box.corner_b_left-Vector2(0,20),0,180,Vector2(25,0),0,0,true)
	
	var bon3 = bone(box.corner_right+Vector2(0,5),0,180,Vector2(0,25),0,0,true)
	var bon4 = bone(box.corner_left+Vector2(0,5),0,180,Vector2(0,25),0,0,true)
	boomerang(bon3,"position:x",bon3.position.x,box.center.x,1).finished.connect(bon3.queue_free)
	boomerang(bon4,"position:x",bon4.position.x,box.center.x,1).finished.connect(bon4.queue_free)
	
	var BONE_NUM = 7
	
	var off = Vector2(0,-6)
	
	var timeout = 100
	var S_bone1 = bone_stab(box.corner_left,0,90,BONE_NUM,30,10,timeout,10,true)
	var S_bone2 = bone_stab(box.corner_bottom+off,0,-90,BONE_NUM,30,10,timeout,10,true)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bon1,"position:x",box.corner_b_left.x+20,0.75).set_trans(Tween.TRANS_SINE)
	tween.tween_property(bon2,"position:x",box.corner_bottom.x-20,0.75).set_trans(Tween.TRANS_SINE)
	tween.chain()
	var change_type = func(): 
		bon1.type = 1 
		bon2.type = 2
	get_tree().create_timer(0.75).timeout.connect(change_type)
	tween.tween_property(bon1,"position:x",box.corner_bottom.x+20,0.75).set_trans(Tween.TRANS_SINE)
	tween.tween_property(bon2,"position:x",box.corner_b_left.x-20,0.75).set_trans(Tween.TRANS_SINE)
	tween.tween_property(bon1,"offset_top",100,0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(bon2,"offset_top",100,0.5).set_trans(Tween.TRANS_SINE)
	
	var play_snd = func(): Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
	create_tween().tween_property(box,"yscale",-10,0.35).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.375).timeout
	for i in BONE_NUM:
		if i == 1 : player.set_mode(PlayerSoul.MODE.RED)
		var front_child = S_bone2.bones.get_child(i)
		var back_child = S_bone1.bones.get_child(-(1+i))
		var duration = 0.1
		var height = 90 if i < BONE_NUM-1 else 75
		
		if front_child != null : 
			play_snd.call()
			var tw = create_tween()
			tw.tween_property(front_child,"offset_top",height,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await tw.finished
		
		if back_child != null : 
			play_snd.call()
			var tw2 = create_tween()
			tw2.tween_property(back_child,"offset_top",height,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await tw2.finished
		
	for elt in S_bone1.bones.get_children():
		create_tween().tween_property(elt,"offset_top",0,0.1)
	for elt in S_bone2.bones.get_children():
		create_tween().tween_property(elt,"offset_top",0,0.1)
	
	create_tween().tween_property(box,"xscale",410,0.35).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.075).timeout
	cross_blaster(box.center,1)
	await get_tree().create_timer(0.375).timeout
	ortho_blaster(box.center,1)
	await get_tree().create_timer(1.35).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"right",false)
	
	var siner : float = 0
	var tt : float = 0
	for i in 30:
		if i % 3 == 0:
			var posi = box.corner_left.lerp(box.corner_right,tt)
			var typ = 0 if i < 27 else 1
			a.append(bone(posi-Vector2(0,30),typ,0,Vector2(0,0),0,0,true))
			var tw = create_tween()
			tw.tween_property(a[-1],"offset_down",140,.75).set_trans(Tween.TRANS_BOUNCE)
			Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
			tt += 1/10.0
		bone(box.corner_right+Vector2(50,0),0,0,Vector2(0,(30+i/2.0)+sin(siner)*20),-8,0,true)
		bone(box.corner_bottom+Vector2(50,0),0,0,Vector2((30+i/2.0)-sin(siner)*20,0),-8,0,true)
		siner += PI/10.0
		await get_tree().create_timer(0.1).timeout
	for i in a.size()-1:
		var tw = create_tween()
		tw.tween_property(a[i],"offset_down",0,0.5).set_trans(Tween.TRANS_CUBIC)
		tw.finished.connect(Callable(a[i],"queue_free"))
	a[-1].type = 2
	await get_tree().create_timer(0.25).timeout
	a[-1].xspeed = 1
	bone_stab(box.corner_bottom+off,0,-90,12,17,10,30,5,true)
	
	var circle = bone_circle(box.center,150,2,4,0,70,0,0,true)
	create_tween().tween_property(circle,"radius",60,1)
	create_tween().tween_property(circle,"angle",360,2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	var red_mode = func():player.set_mode(PlayerSoul.MODE.RED)
	get_tree().create_timer(0.7).timeout.connect(red_mode)
	
	var b1 = bone(box.corner_right,0,-45,Vector2(15,15),0,0,true)
	var b2 = bone(box.corner_bottom,0,45,Vector2(15,15),0,0,true)
	var b3 = bone(box.corner_left,0,45,Vector2(15,15),0,0,true)
	var b4 = bone(box.corner_b_left,0,-45,Vector2(15,15),0,0,true)
	var twee = create_tween()
	twee.set_parallel()
	twee.tween_property(box,"yscale",-10,0.75)
	twee.tween_property(b1,"position",box.center-Vector2(40,0),0.75).set_trans(Tween.TRANS_SINE)
	twee.tween_property(b2,"position",box.center-Vector2(40,0),0.75).set_trans(Tween.TRANS_SINE)
	twee.tween_property(b3,"position",box.center+Vector2(40,0),0.75).set_trans(Tween.TRANS_SINE)
	twee.tween_property(b4,"position",box.center+Vector2(40,0),0.75).set_trans(Tween.TRANS_SINE)
	twee.chain()
	twee.tween_property(b1,"angle",-90,0.15).set_trans(Tween.TRANS_SINE)
	twee.tween_property(b2,"angle",90,0.15).set_trans(Tween.TRANS_SINE)
	twee.tween_property(b3,"angle",90,0.15).set_trans(Tween.TRANS_SINE)
	twee.tween_property(b4,"angle",-90,0.15).set_trans(Tween.TRANS_SINE)
	twee.chain()
	twee.tween_property(b1,"position:y",-200,1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	twee.tween_property(b2,"position:y",680,1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	twee.tween_property(b3,"position:y",-200,1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	twee.tween_property(b4,"position:y",680,1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	for i in 3:
		var bo = bone(Vector2(box.corner_bottom.x+60,320),2,0,Vector2(50,50),-4,0,true)
		var bo2 = bone(Vector2(box.corner_b_left.x-60,320),2,0,Vector2(50,50),4,0,true)
		bo.ang_spd = 0.5
		bo2.ang_spd = -0.5
		if i == 1:
			circle.type = 1
			fs_gaster_blaster(box.center-Vector2(0,500),Vector2(320,100),0,1,0,0,0)
			fs_gaster_blaster(box.corner_left-Vector2(0,500),Vector2(260,100),0,1.15,0,20,0)
			fs_gaster_blaster(box.corner_right-Vector2(0,500),Vector2(380,100),0,1.15,0,20,0)
		if i == 0:
			var bone1 = bone(Vector2(320,box.corner_right.y-20),0,90,Vector2(41,41),0,0,true)
			var bone2 = bone(Vector2(320,box.corner_bottom.y+20),0,90,Vector2(41,41),0,0,true)
			var bone3 = bone(Vector2(box.corner_left.x-20,310),0,0,Vector2(41,41),0,0,true)
			var bone4 = bone(Vector2(box.corner_right.x+20,310),0,0,Vector2(41,41),0,0,true)
			boomerang(bone1,"position:y",box.corner_right.y-20,260,1).finished.connect(func():bone1.queue_free())
			boomerang(bone2,"position:y",box.corner_bottom.y+20,360,1).finished.connect(func():bone2.queue_free())
			boomerang(bone3,"position:x",box.corner_left.x-20,270,1).finished.connect(func():bone3.queue_free())
			boomerang(bone4,"position:x",box.corner_right.x+20,370,1).finished.connect(func():bone4.queue_free())
		await get_tree().create_timer(0.4).timeout
	
	await get_tree().create_timer(1.5).timeout
	var dial = ["Let's make it quick."]
	main.enemy_manager.enemies[0].sprite.look_right()
	main.enemy_manager.enemies[0].writer.set_dialogue(dial,false)
	main.enemy_manager.enemies[0].writer.next_string()
	await main.enemy_manager.enemies[0].writer.dialogue_finished
	attacks_manager.attack_end()

func ortho_blaster(_pos:Vector2,_size:float,_spd=4):
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y-100),0,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y+100),180,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y),-90,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y),90,_size,0,0,0,_spd)

func cross_blaster(_pos:Vector2,_size:float,_spd=4):
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y-100),-45,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y+100),-45-90,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y-100),45,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y+100),90+45,_size,0,0,0,_spd)

func attack_finished():
	Global.display.fade(Color.WHITE,G_Display.TYPE.OUT,1)
	attacks_manager.pattern = ["res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack1.gd",
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack2.gd",
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack3.gd",
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack4.gd",
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack5.gd",
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack6.gd",
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 1 HM/attack7.gd",
			
			"res://Scripts/AttacksPatterns/FS!Sans HardMode/Phase 2 HM/attack0.gd"]
	main.camera.zoom*=2
	main.continuity.intr = 2
	main.event_manager.turn = 0
	main.enemy_manager.enemies[0].can_wave = true
	main.enemy_manager.enemies[0].sprite.normal()
	main.gradient.visible = true
	main.gradient.modulate = Color.MEDIUM_PURPLE
	var tween = get_tree().create_tween()
	tween.tween_property(main.camera,"zoom",Vector2(1,1),1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.play()
	Global.sound_player.play_bgm(main.battle.Sound)

