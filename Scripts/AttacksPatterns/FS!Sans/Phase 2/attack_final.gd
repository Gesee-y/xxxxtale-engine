extends AttackPattern

signal attack_done
signal next
signal can_push_down
signal final_strike

var can_scroll : bool = false
var scroll_spd = 5
var turn_locked = false
var state = 0
var timer = 0
var last = 0
var multiplier = 1
var seen = 0
var can_attack = false
var button : AnimatedSprite2D

var ZZZ = preload("res://Sprites/Enemies/zzz.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,-10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if can_scroll:
		main.back_layer.position.x -= scroll_spd
		main.back_layer.size.x += scroll_spd
	if turn_locked:
		if abs(player.position.x - box.bound[1]) < 15 and !can_attack:
			player.position.x = 320
			last = main.enemy_manager.enemies[0].sprite.head.frame
			main.enemy_manager.enemies[0].sprite.red_eye_nerfed()
			if state >0 and state < 3:
				multiplier = state
				state = 1
			timer = 0
			Global.sound_player.play_sfx("res://Sounds/SFX/bell.ogg")
			get_tree().create_timer(0.1).connect("timeout",func(): main.enemy_manager.enemies[0].sprite.head.frame = last)
		else:
			if main.enemy_manager.enemies[0].writer.stop:
				match state:
					0:
						main.enemy_manager.enemies[0].sprite.normal()
						if timer > 520 :
							if seen == 0:
								seen = 1
								next.emit()
							state = 1
							timer = 0
					1:
						main.enemy_manager.enemies[0].sprite.black_eye_3()
						if timer > 920 :
							if seen ==1 :
								seen = 2
								next.emit()
							state = 2
							timer = 0
					2:
						main.enemy_manager.enemies[0].sprite.black_eye_2()
						if timer > 820 :
							if 2 == seen:
								seen = 3
								next.emit()
							state = 3
							timer = 0
					3:
						if timer < 200:
							main.enemy_manager.enemies[0].sprite.black_eye_1()
							main.enemy_manager.enemies[0].sprite.spd1 = 2.5
							main.enemy_manager.enemies[0].sprite.spd2 = 5
						elif timer < 600:
							main.enemy_manager.enemies[0].sprite.normal()
							main.enemy_manager.enemies[0].sprite.spd1 = 2
							main.enemy_manager.enemies[0].sprite.spd2 = 4
						elif timer < 850:
							main.enemy_manager.enemies[0].sprite.eye_closed()
							main.enemy_manager.enemies[0].sprite.spd1 = 1.5
							main.enemy_manager.enemies[0].sprite.spd2 = 3
						elif timer > 1200:
							main.enemy_manager.enemies[0].sprite.spd1 = 1
							main.enemy_manager.enemies[0].sprite.spd2 = 2
							if timer % 40 == 0:
								emit_Z()
								if seen == 3 :
									seen = 4
									button = make_attack_button()
									next.emit()
								can_attack = true
	
	if box.xpos < -220 and box.can_push == "left":
		can_push_down.emit()
	if box.ypos > 80 and box.can_push == "down":
		box.can_push = ""
	if button != null:
		if button.animation == "selected":
			if Input.is_action_just_pressed("accept"):
				final_strike.emit()
				turn_locked = false
				state = 4
	
	timer += 1*multiplier

func emit_Z():
	var Z = Sprite2D.new()
	Z.texture = ZZZ
	Z.position = main.enemy_manager.enemies[0].position+Vector2(30,-50)
	Z.scale = Vector2.ZERO
	add_child(Z)
	var Ztween = create_tween()
	Ztween.set_parallel()
	Ztween.tween_property(Z,"scale",Vector2(1,1),1).set_trans(Tween.TRANS_SINE)
	Ztween.tween_property(Z,"position",Vector2(100,-200),2).as_relative().set_trans(Tween.TRANS_SINE)
	Ztween.finished.connect(Z.queue_free)

func make_attack_button():
	var attackB = AnimatedSprite2D.new()
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(100,35)
	area.add_child(collision)
	area.body_entered.connect(func(_body):if _body is PlayerSoul : attackB.animation = "selected")
	area.body_exited.connect(func(_body):if _body is PlayerSoul: attackB.animation = "normal")
	
	var OATk : AnimatedSprite2D = main.button_controller.get_child(0)
	attackB.sprite_frames = OATk.sprite_frames
	attackB.position = OATk.position
	attackB.add_child(area)
	
	add_child(attackB)
	return attackB

func pre_attack():
	pass

func main_attack():
	blasters_and_a_cross()
	await attack_done
	
	Global.display.click(0.5)
	await get_tree().create_timer(0.25).timeout
	player.global_position = box.center
	await get_tree().create_timer(0.23).timeout
	
	for i in 4:
		var dir = ["up","down","left","right"].pick_random() if i < 3 else "left"
		player.set_mode(PlayerSoul.MODE.BLUE,dir,true)
		match dir:
			"up":
				bone_stab(box.corner_right+Vector2(0,-5),0,180,30,30,25,5)
				bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,30,25,5)
				bone_stab(box.corner_left-Vector2(10,0),0,90,12,30,25,5)
			"down":
				bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,30,25,5)
				bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,30,25,5)
				bone_stab(box.corner_left-Vector2(10,0),0,90,12,30,25,5)
			"right":
				bone_stab(box.corner_right+Vector2(0,-5),0,180,30,30,25,5)
				bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,30,25,5)
				bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,30,25,5)
			"left":
				bone_stab(box.corner_left-Vector2(10,0),0,90,12,30,25,5)
				bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,30,25,5)
				bone_stab(box.corner_right+Vector2(0,-5),0,180,30,30,25,5)
		
		var off = Vector2(200,0)
		var off2 = Vector2(0,200)
		bone(box.center-off,2,0,Vector2(60,60),12,0,true) # Left Orange Bone
		bone(box.center+off,2,0,Vector2(60,60),-12,0,true) # Right Orange Bone
		bone(box.center-off2,2,90,Vector2(60,60),0,12,true) # Up Orange Bone
		bone(box.center+off2,2,90,Vector2(60,60),0,-12,true) # Down Orange Bone
	
		await get_tree().create_timer(0.82).timeout
	
	var box_tween = create_tween()
	box_tween.set_parallel()
	box_tween.tween_property(box,"xscale",-100,0.75).set_trans(Tween.TRANS_SINE)
	box_tween.tween_property(box,"xpos",100,0.75).set_trans(Tween.TRANS_SINE)
	box_tween.chain()
	box_tween.tween_property(box,"xpos",0,0.5).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.75).timeout
	player.set_mode(PlayerSoul.MODE.RED,"right",false,1)
	can_scroll = true
	
	var siner : float = 0
	
	for x in 2:
		for i in 4:
			if x != 0:
				if i % 2 == 0:
					bone(box.corner_right,0,0,Vector2(0,70),-6,0,true)
					bone(box.corner_right+Vector2(20,0),0,0,Vector2(0,50),-6,0,true)
				else:
					bone(box.corner_bottom,0,0,Vector2(70,0),-6,0,true)
					bone(box.corner_bottom+Vector2(20,0),0,0,Vector2(50,0),-6,0,true)
			else:
				if i % 2 == 0 and i != 0:
					bone(box.corner_right,0,0,Vector2(0,70),-6,0,true)
					bone(box.corner_right+Vector2(20,0),0,0,Vector2(0,50),-6,0,true)
				else:
					bone(box.corner_bottom,0,0,Vector2(70,0),-6,0,true)
					bone(box.corner_bottom+Vector2(20,0),0,0,Vector2(50,0),-6,0,true)
			
			await get_tree().create_timer(0.5).timeout
			
		await get_tree().create_timer(0.25).timeout
		for i in 30:
			bone(box.corner_right+Vector2(50,0),0,0,Vector2(0,(30+i/2.0)+sin(siner)*20),-8,0,true)
			bone(box.corner_bottom+Vector2(50,0),0,0,Vector2((30+i/2.0)-sin(siner)*20,0),-8,0,true)
			siner += PI/15.0
			await get_tree().create_timer(0.1).timeout
			
	await get_tree().create_timer(1).timeout
	can_scroll = false
	box_tween = create_tween()
	box_tween.set_parallel()
	box_tween.tween_property(main.back_layer,"position:x",-fmod(main.back_layer.position.x,640),0.75).as_relative().set_trans(Tween.TRANS_SINE)
	box_tween.tween_property(box,"xpos",-200,0.75).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.75).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"right",true)
	bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,60,25,5)
	await get_tree().create_timer(1.5).timeout
	
	
	for i in 3:
		Global.display.click(0.5)
		await get_tree().create_timer(0.035).timeout
		player.set_mode(PlayerSoul.MODE.RED)
		box.xpos = 0
		box.xscale = 400
		await get_tree().create_timer(0.455).timeout
		clear_mask(true)
		player.last = Vector2(320,320)
		player.position = Vector2(320,320)
		
		await get_tree().create_timer(0.035).timeout
		left_or_right()
		await attack_done
	
	Global.display.click(0.5)
	await get_tree().create_timer(0.495).timeout
	player.position = box.center
	player.set_mode(PlayerSoul.MODE.RED)
	clear_mask(true)
	
	var bones = bone_circle(box.center+Vector2(-3,0),120,0,12,4,60,0,0,true)
	for i in 80:
		var pos = box.center+to_cartesian_from_polar(150,PI/20.0*i)
		var pos2 = box.center+to_cartesian_from_polar(150,PI/20.0*i+PI/2)
		
		fs_gaster_blaster(pos-to_cartesian_from_polar(150,PI/20.0*i+PI/2)*5,
				pos,rad_to_deg(PI/20.0*i+PI/2.0),0.4)
		
		fs_gaster_blaster(pos2-to_cartesian_from_polar(150,PI/20.0*i)*5,
				pos2,rad_to_deg(PI/20.0*i+PI),0.4)
		
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(1).timeout
	create_tween().tween_property(bones,"bone_size",160,0.5).set_trans(Tween.TRANS_SINE)
	bones.type = 1
	
	for i in 20:
		var _pos = Vector2(randi_range(100,500),randi_range(150,400))
		var start_pos = Vector2([randi_range(-100,-20),randi_range(660,740)].pick_random(),
				[randi_range(-100,-20),randi_range(500,600)].pick_random())
		var _ang = angle_to_target(_pos,player.global_position)
		
		fs_gaster_blaster(start_pos,_pos,_ang,1,0,120-6*i,60,6)
		await get_tree().create_timer(0.1).timeout
	
	Global.player_immortal = true
	await get_tree().create_timer(1).timeout
	
	Global.display.fade()
	await get_tree().create_timer(0.25).timeout
	clear_mask()
	Global.sound_player.fade_all_music()
	await get_tree().create_timer(1).timeout
	main.gradient.visible = false
	main.particule.visible = false
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT)
	await get_tree().create_timer(1).timeout
	
	await get_tree().create_timer(2).timeout
	turn_locked = true
	var sans = main.enemy_manager.enemies[0]
	var dialogue = [
		["{sans:eye_closed}*sigh*You are still there, huh?",
				"{sans:normal}Even after that...you keep going",
				"{sans:look_right}But don't think it's finish yet.",
				"{sans:normal}I know that if I let you for this turn,{P1} you will just kill me.",
				"{sans:eye_closed}So, that is my plan,{P1} I will not let you have your turn.",
				"{sans:normal}I will stop you even if it mean to stay there forever."
		],
		
		[
			"{sans:black_eye_1}I know your kind.",
			"{sans:look_right}You are the kind of person who want to see the bottom of things.",
			"{sans:eye_closed}You just do it 'cause you want to do it.",
			"{sans:black_eye_2}And because you want to do it, you had to do it."
		],
		
		[
			"{sans:look_right}But now *yawn* you should just... give up.",
			"{sans:black_eye_1}We have nothing more to give you."
		]
		
	]
	
	sans.writer.set_dialogue(dialogue[0])
	sans.writer.next_string()
	await sans.writer.dialogue_finished
	timer = 0
	await next
	
	sans.writer.set_dialogue(dialogue[1])
	sans.writer.next_string()
	await sans.writer.dialogue_finished
	timer = 0
	await next
	
	sans.writer.set_dialogue(dialogue[2])
	sans.writer.next_string()
	await sans.writer.dialogue_finished
	timer = 0
	await next
	
	box.can_push = "left"
	await can_push_down
	main.button_controller.get_child(0).z_index = 10
	box.can_push = "down"
	
	await final_strike
	await attack_enemy(0,Global.players[0].weapon)
	sans.mode = "hit"
	main.enemy_manager.enemies[0].can_wave = false
	sans.sprite.look_right()
	
	var dodge_dialogue =["Huh, you really think it would be"]
	
	sans.writer.set_dialogue(dodge_dialogue,false,false,true)
	sans.writer.next_string()
	await sans.writer.string_finished
	
	sans.sprite.head.frame = 7 
	sans.writer.next_string()
	await attack_enemy(0,Global.players[0].weapon)
	await get_tree().create_timer(1).timeout
	
	main.event_manager.turn = 0
	attacks_manager.pattern = ["res://Scripts/AttacksPatterns/FS!Sans/death_cutscene.gd"]
	
	attacks_manager.set_attack("res://Scripts/AttacksPatterns/FS!Sans/death_cutscene.gd")
	attacks_manager.current_attack.main = main
	attacks_manager.current_attack.box = box
	attacks_manager.current_attack.player = player
	
	attacks_manager.start_attack()
	

func attack_enemy(_idx,_weapon:WeaponData):
	var enemy : Enemy = main.enemy_manager.enemies[_idx]
	var _animation : AnimatedSprite2D = AnimatedSprite2D.new()
	_animation.sprite_frames =_weapon.animation
	_animation.position = Vector2(enemy.global_position.x,
			enemy.global_position.y - 10)
	get_parent().get_parent().add_child(_animation)
	_animation.z_index =2
	_animation.play("default")
	_animation.animation_finished.connect(Callable(_animation,"queue_free"))
	Global.sound_player.play_sfx(_weapon.sound)
	match enemy.mode: 
		"hit":
			await _animation.animation_finished
			await enemy.show_damage(9999999,enemy.xpos)
			enemy.ReadyForBattle = true
		"miss":
			enemy.enemy_dodge(_animation)

func to_cartesian_from_polar(_radius:float,_angle:float):
	var x = _radius * cos(_angle)
	var y = _radius * sin(_angle)
	return Vector2(x,y)

func left_or_right():
	box.xscale = 420
	box.yscale = -10
	player.position = box.center
	player.lock = false
	
	var dir = ["up","down","left","right"].pick_random()
	player.set_mode(PlayerSoul.MODE.BLUE,dir,true)
	var wait = 16
	match dir:
		"left":
			bone_stab(box.corner_left,0,90,12,30,wait,60)
		"up":
			bone_stab(box.corner_right,0,180,15,30,wait,60,5)
		"down":
			bone_stab(box.corner_b_left,0,0,13,30,wait,5)
		"right":
			bone_stab(box.corner_bottom,0,-90,12,30,wait,60)
	
	await get_tree().create_timer(0.8).timeout
	attack_done.emit()

func blasters_and_a_cross():
	
	# We adjust the box size
	box.xscale = 400
	box.yscale = -10
	
	# And set the player
	player.position = box.center
	player.lock = false
	
	ortho_blaster(box.center,1,4)
	await get_tree().create_timer(0.3).timeout
	
	# We create some blaster to make a X
	cross_blaster(box.center,1,4)
	await get_tree().create_timer(0.3).timeout
	
	# And another for a +
	ortho_blaster(box.center,1,4)
	
	await get_tree().create_timer(1.5).timeout
	
	attack_done.emit()

func ortho_blaster(_pos:Vector2,_size:float,_spd:float=3):
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y-100),0,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y+100),180,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y),-90,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y),90,_size,0,0,0,_spd)

func cross_blaster(_pos:Vector2,_size:float,_spd:float=3):
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y-100),-45,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y+100),-45-90,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y-100),45,_size,0,0,0,_spd)
	fs_gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y+100),90+45,_size,0,0,0,_spd)


func attack_finished():
	pass

