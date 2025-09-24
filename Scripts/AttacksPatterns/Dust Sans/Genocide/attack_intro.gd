extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	var wait = 10
	
	# Part 1
	player.set_mode(PlayerSoul.MODE.BLUE,"left",true)
	bone_stab(box.corner_left+Vector2(-10,0),0,90,12,30,wait,60)
	
	await get_tree().create_timer(0.35).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"up",true)
	bone_stab(box.corner_right+Vector2(0,-10),0,180,25,30,wait,60,5)
	
	await get_tree().create_timer(0.35).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	bone_stab(box.corner_b_left+Vector2(0,5),0,0,25,10,wait,3)
	var b1 = bone(box.center+Vector2(0,-150),0,90,Vector2(60,60),0,0,true)
	var b2 = bone(box.center+Vector2(-150,0),0,0,Vector2(60,60),0,0,true)
	var b3 = bone(box.center+Vector2(150,0),0,0,Vector2(60,60),0,0,true)
	
	var boomerang_dur = 1.5
	boomerang(b1,"position:y",box.center.y-150,box.center.y+35,boomerang_dur).finished.connect((b1.queue_free))
	boomerang(b2,"position:x",box.center.x-150,box.center.x+60,boomerang_dur).finished.connect((b2.queue_free))
	await get_tree().create_timer(boomerang_dur/2.0).timeout
	boomerang(b3,"position:x",box.center.x+150,box.center.x+30,boomerang_dur).finished.connect((b3.queue_free))
	await get_tree().create_timer(boomerang_dur/2.0).timeout
	
	# Part 2
	var Xoff = 40
	Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
	var b4 = bone(box.corner_bottom+Vector2(Xoff,0),0,-45,Vector2(50,0),0,0,true)
	var b5 = bone(box.corner_b_left-Vector2(Xoff,0),0,45,Vector2(50,0),0,0,true)
	
	
	var circ = bone_circle(box.center,120,0,15,0,70,0,0,true)
	var tween1 = create_tween()
	tween1.set_parallel()
	tween1.tween_property(b4,"position:x",box.corner_b_left.x+15,1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween1.tween_property(b5,"position:x",box.corner_bottom.x-15,1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween1.tween_property(b4,"angle",0,0.75).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(b5,"angle",0,0.75).set_trans(Tween.TRANS_SINE)
	
	tween1.tween_property(circ,"radius",80,2).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(circ,"angle",180,2).set_trans(Tween.TRANS_SINE)
	tween1.chain()
	tween1.tween_property(b4,"offset_top",120,0.5).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(b5,"offset_top",120,0.5).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.5).timeout
	for i in 5:
		var Xpos = randi_range(box.corner_left.x,box.corner_right.x)
		var ang = randi_range(-180,180)
		var rnd_add = randi_range(-60,60)
		var b = bone(Vector2(Xpos,box.corner_right.y-randi_range(20,40)),2,ang,Vector2(10,10),0,3,true)
		create_tween().tween_property(b,"angle",rnd_add,1).as_relative().set_trans(Tween.TRANS_SINE)
	
	var b = bone(box.center+Vector2(0,100),0,0,Vector2(10,0),0,0,true)
	boomerang(b,"offset_top",50,130,0.5)
	
	get_tree().create_timer(0.25).timeout.connect(func(): 
					Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg")
					main.camera.shake = 10)
					
	
	await get_tree().create_timer(0.5).timeout
	b.type = 2
	
	player.set_mode(PlayerSoul.MODE.RED)
	
	boomerang(b,"offset_top",50,120,0.25,10).loop_finished.connect(func(_x):
					b.angle = randi_range(-30,30)
					main.camera.shake = 2
					Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg"))
	box.bg.color = Color.ORANGE
	Global.sound_player.play_sfx("res://Sounds/SFX/flash.ogg")
	for i in 4:
		
		if i == 0:
			create_tween().tween_property(circ,"ang_spd",2,1)
			dust_gaster_blaster(Vector2(box.center.x,-100),Vector2(box.center.x,100),0,0.4,0,3,0,3)
			for x in 7:
				bone(box.corner_b_left-Vector2(0,22*x),1,0,Vector2(3,3),2+x/4.0,0,true)
		elif i == 1:
			dust_gaster_blaster(Vector2(box.center.x-30,-100),Vector2(box.center.x-30,100),0,0.4,0,3,0,3)
			dust_gaster_blaster(Vector2(box.center.x+30,-100),Vector2(box.center.x+30,100),0,0.4,0,3,0,3)
			for x in 7:
				bone(box.corner_bottom-Vector2(0,22*x),1,0,Vector2(3,3),-2-x/4.0,0,true)
		elif i == 2:
			for bon in circ.bones.get_children():
				var twee = create_tween()
				twee.tween_property(bon,"angle",60,0.5).as_relative().set_trans(Tween.TRANS_SINE)
			Global.sound_player.play_sfx("res://Sounds/SFX/flash.ogg")
			box.bg.color = Color.BLACK
			var c = bone_circle(box.center-Vector2(120,0),30,0,3,2,1,3,0,true)
			create_tween().tween_property(c,"bone_size",15,1).set_trans(Tween.TRANS_SINE)
		elif i == 3:
			for bon in circ.bones.get_children():
				var twee = create_tween()
				twee.tween_property(bon,"angle",-120,1).as_relative().set_trans(Tween.TRANS_SINE)
			var c = bone_circle(box.center+Vector2(120,0),30,0,3,-2,1,-3,0,true)
			create_tween().tween_property(c,"bone_size",15,1).set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.5).timeout
	
	b.type = 0
	
	var tween2 = create_tween()
	tween2.set_parallel()
	
	tween2.tween_property(b,"angle",0,0.3).set_trans(Tween.TRANS_SINE)
	tween2.tween_property(b,"offset_top",150,0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	cross_blaster(box.center,0.6)
	await get_tree().create_timer(0.25).timeout
	b4.type = 2
	b4.xspeed = 3
	b5.type = 1
	b5.xspeed = -3
	for bon in circ.bones.get_children():
		var twee = create_tween()
		twee.tween_property(bon,"angle",60,0.5).as_relative().set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.25).timeout
	create_tween().tween_property(circ,"radius",20,0.35).as_relative().set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.75).timeout
	b.type = 1
	var tt = create_tween()
	tt.tween_property(b,"position:x",-60,0.5).as_relative().set_trans(Tween.TRANS_SINE)
	tt.tween_property(b,"position:x",180,1.5).as_relative().set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.5).timeout
	b.type = 2
	
	await get_tree().create_timer(2).timeout
	
	# End
	var dial = ["{sans:eye_closed}He.","Hope you are not already exhausted.","{sans:normal}The game just start."]
	main.enemy_manager.enemies[0].sprite.look_right()
	main.enemy_manager.enemies[0].writer.set_dialogue(dial,false)
	main.enemy_manager.enemies[0].writer.next_string()
	
	await main.enemy_manager.enemies[0].writer.dialogue_finished
	attacks_manager.attack_end()


func cross_blaster(_pos:Vector2,_size:float,_spd:float=3):
	dust_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y-100),-45,_size,0,0,0,_spd)
	dust_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y+100),-45-90,_size,0,0,0,_spd)
	dust_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y-100),45,_size,0,0,0,_spd)
	dust_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y+100),90+45,_size,0,0,0,_spd)


func attack_finished():
	Global.sound_player.play_bgm(main.battle.Sound)
	main.enemy_manager.enemies[0].can_wave = true
	attacks_manager.main.event_manager.turn += 1
	attacks_manager.pattern = [
		#"res://Scripts/AttacksPatterns/DustSans/Genocide/Paps/attack_intro.gd",
		"res://Scripts/AttacksPatterns/DustSans/Genocide/attack1.gd",
		"res://Scripts/AttacksPatterns/DustSans/Genocide/attack2.gd",
		"res://Scripts/AttacksPatterns/DustSans/Genocide/attack3.gd",
		"res://Scripts/AttacksPatterns/DustSans/Genocide/attack4.gd",
		"res://Scripts/AttacksPatterns/DustSans/Genocide/attack5.gd",
		"res://Scripts/AttacksPatterns/DustSans/Genocide/Paps/attack_intro.gd"
	]

