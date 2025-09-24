extends AttackPattern

signal attack_done
var count = 0
var max_count = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	attack_done.connect(_on_attack_done)

func main_attack():
	_on_attack_done()

func stars_and_opening():
	# We set the box size
	box.xscale = 420
	box.yscale = 10
	# We adjust the player position and his soul mode
	player.position = box.center+Vector2(0,-10)
	player.set_mode(PlayerSoul.MODE.BLUE)
	
	# A little hold up 
	await get_tree().create_timer(0.05).timeout
	
	# We unlock th player so that he can move
	player.lock = false
	
	# The star who pass on the floor and animated with a boomerang movement
	var star_pos = box.corner_b_left+Vector2(-50,-10)
	var star = bone_polygon(star_pos,10,0,5,3,0,0,true)
	boomerang(star,"position:x",star_pos.x,box.corner_bottom.x,0.75)
	
	# Another hold up
	await get_tree().create_timer(0.4).timeout
	
	# Some hold up time to avoid magical numbers
	var wait_time = 0.4
	var trans_time = 0.45
	
	# Another bonestap on the left so the player will be forced to go to the right
	bone_stab(box.corner_left,0,90,12,50,20,(wait_time+trans_time)*60)
	await get_tree().create_timer(trans_time).timeout
	
	# Some bone opening to greet the player
	for i in 2:
		var off = Vector2(50,0)
		var offY = Vector2(25,-5)
		opening(box.corner_left+Vector2(off.x,offY.x),box.corner_b_left+Vector2(off.x,offY.y),6)
		opening(box.corner_right+Vector2(off.x,offY.x),box.corner_bottom+Vector2(off.x,offY.y),-6)
		await get_tree().create_timer(wait_time).timeout
	
	await get_tree().create_timer(0.25).timeout
	attack_done.emit()

func blasters_and_a_cross():
	
	# We adjust the box size
	box.xscale = 400
	box.yscale = -10
	
	# And set the player
	player.position = box.center
	player.lock = false
	
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

func two_bone_range():
	var dir = ["up","down"].pick_random()
	box.xscale = 150
	box.yscale = 0
	player.position = box.center
	player.lock = false
	player.set_mode(PlayerSoul.MODE.BLUE,dir)
	
	for i in 30:
		if i % 2 == 0 and i != 0:
			match dir:
				"up":
					var off = Vector2(0,0)
					two_bone(box.corner_right+off,30,-3,0,true)
				"down":
					var off = Vector2(30,-20)
					_sBone(box.corner_right+off,20,-3,true)
		elif i!=0:
			match dir:
				"down":
					var off = Vector2(0,-40)
					two_bone(box.corner_b_left+off,30,3,0)
				"up":
					var off = Vector2(0,10)
					_sBone(box.corner_b_left+off,-20,3)
		if i == 13:
			attack_done.emit()
			break
		if i % 3 == 0 : bone(box.corner_left+Vector2(-30,-40),(i%2)+1,45,Vector2(100,100),10,4,true)
		await get_tree().create_timer(0.4).timeout

func _sBone(_pos:Vector2,_angle:float,xspd=3,_inv:bool = false):
	for i in 2:
		sine_bone(_pos,_angle,80,100,_inv).xspeed = xspd
		await get_tree().create_timer(0.05).timeout

func sine_bone(_pos:Vector2,angle:float,_ini:float=80,fin:float=100,_inv:bool = false):
	var bbon = bone(_pos,0,angle,Vector2(_ini,0),0,0,true)
	var twe = create_tween()
	twe.set_loops(10)
	var prop = "top" if !_inv else "down"
	twe.tween_property(bbon,"offset_"+prop,fin,0.35).set_trans(Tween.TRANS_SINE)
	twe.tween_property(bbon,"offset_"+prop,_ini,0.35).set_trans(Tween.TRANS_SINE)
	return bbon

func two_bone(_pos:Vector2,_size:float,_xspd:float,_yspd:float,reverse:bool = false):
	var off = Vector2(_size/2.0,0)
	var multiplier = 1 if reverse else -1
	
	bone(_pos+off,0,50*multiplier,Vector2(0,_size),_xspd,_yspd,true)
	bone(_pos-off,0,-50*multiplier,Vector2(0,_size),_xspd,_yspd,true)

func bone_tornado():
	var siner : float = 0
	box.xscale = 420
	box.yscale = -10
	player.position = box.center
	player.lock = false
	var _size = 35
	for i in 50:
		var b1 = bone(box.corner_right+Vector2(50,0),0,0,Vector2(0,(_size)+sin(siner)*20),0,0,true)
		var b2 = bone(box.corner_bottom+Vector2(50,0),0,0,Vector2((_size)-sin(siner)*20,0),0,0,true)
		
		boomerang(b1,"position:x",b1.position.x,box.corner_left.x,1.5)
		boomerang(b2,"position:x",b2.position.x,box.corner_left.x,1.5)
		if i == 35:
			attack_done.emit()
			break
		
		siner += PI/10.0
		await get_tree().create_timer(0.1).timeout

func left_or_right():
	box.xscale = 420
	box.yscale = -10
	player.position = box.center
	player.lock = false
	await get_tree().create_timer(0.05).timeout
	var dir = ["up","down","left","right"].pick_random()
	player.set_mode(PlayerSoul.MODE.BLUE,dir,true)
	var wait = 16
	match dir:
		"left":
			bone_stab(box.corner_left,0,90,12,30,wait,60)
		"up":
			bone_stab(box.corner_right,0,180,25,30,wait,60,5)
		"down":
			bone_stab(box.corner_b_left,0,0,25,30,wait,5)
		"right":
			bone_stab(box.corner_bottom,0,-90,12,30,wait,60)
	
	await get_tree().create_timer(1).timeout
	attack_done.emit()

func blaster_massacre():
	box.xscale = 420
	box.yscale = -10
	player.position = box.center
	player.lock = false
	
	for i in 30:
		var _pos = Vector2(randi_range(100,500),randi_range(150,400))
		var start_pos = Vector2([randi_range(-100,-20),randi_range(660,740)].pick_random(),
				[randi_range(-100,-20),randi_range(500,600)].pick_random())
		var _ang = randi_range(0,360)
			
		fs_gaster_blaster(start_pos,_pos,_ang,0.6,0)
		
		if i == 20:
			attack_done.emit()
			break
		await get_tree().create_timer(0.25).timeout

func circle_and_blaster():
	box.xscale = 400
	box.yscale = -10
	await get_tree().create_timer(0.05).timeout
	player.position = box.center+Vector2(0,-30)
	player.lock = false
	
	bone_stab(box.corner_b_left+Vector2(-10,10),0,0,20,20,15,500)
	
	plateform(box.center+Vector2(-60,0),0,0,40,Vector2.ZERO,true)
	plateform(box.center+Vector2(20,0),0,0,40,Vector2.ZERO,true)
	
	bone(Vector2(box.center+Vector2(0,10)),
		0,0,Vector2(0,85-25),0,0,true)
	
	bone_circle(Vector2(box.corner_left.x+40,box.corner_left.y+50),30,2,4,2,20,0,0,true)
	bone_circle(Vector2(box.corner_right.x-40,box.corner_right.y+50),30,2,4,-2,20,0,0,true)
	
	await get_tree().create_timer(0.15).timeout
	
	player.set_mode(PlayerSoul.MODE.BLUE)
	for i in 5:
		if i %2==0:
			fs_gaster_blaster(Vector2(0,-30),Vector2(box.center.x-40,150),0,1,0,0,0,4)
		else:
			fs_gaster_blaster(Vector2(640,-30),Vector2(box.center.x+40,150),0,1,0,0,0,4)
		await get_tree().create_timer(0.8).timeout
	
	attack_done.emit()

func _on_attack_done():
	var attacks : Array[Callable] = [
		stars_and_opening,
		blasters_and_a_cross,
		two_bone_range,
		bone_tornado,
		left_or_right,
		blaster_massacre,
		circle_and_blaster
	]
	
	var sans = main.enemy_manager.enemies[0]
	var expres : Array[Callable] = [
		sans.sprite.eye_closed,
		sans.sprite.red_eye_nerfed,
		sans.sprite.black_eye_2
	]
	
	Global.display.click(0.5)
	Global.sound_player.pause_music(main.battle.Sound)
	await get_tree().create_timer(0.005).timeout
	player.set_mode(PlayerSoul.MODE.RED)
	clear_attack(true)
	player.lock = true
	count += 1
	await get_tree().create_timer(0.49).timeout
	clear_attack(true)
	player.lock = false
	resume_music()
	
	if count < max_count:
		var expr = expres.pick_random()
		var atk = attacks.pick_random()
		expr.call()
		atk.call()
	else:
		attacks_manager.attack_end()
		sans.can_wave = true
		sans.sprite.normal()

func opening(pos1:Vector2,pos2:Vector2,_spd:float=-2,op_pos=20):
	var up = Vector2.UP*5
	var rnd = op_pos
	bone(pos1+up,0,0,Vector2(rnd,35),_spd,0,true)
	bone(pos2+up,0,0,Vector2(0,85-rnd),_spd,0,true)

func resume_music():
	if !Global.sound_player.now_playing.is_empty():
		Global.sound_player.resume_music(main.battle.Sound)
	else:
		Global.sound_player.play_bgm(main.battle.Sound)

func attack_finished():
	pass

