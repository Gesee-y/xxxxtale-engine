extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(300,40)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.BLUE)
	
	bone_appear2(box.corner_b_left+Vector2(-20,65))
	bone_appear2(box.corner_right+Vector2(20,-65),40,40,0,180)
	
	fs_gaster_blaster(Vector2(0,0),Vector2(150,150),
			angle_to_target(Vector2(150,150),box.center),0.8,0,0,5,10)
	fs_gaster_blaster(Vector2(0,0),Vector2(150+320,150),
			angle_to_target(Vector2(150+320,150),box.center),0.8,0,0,5,10)
	await get_tree().create_timer(0.5).timeout
	fs_gaster_blaster(Vector2(660,400),Vector2(box.center.x+200,320),90)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.RED)
	bone_circle(Vector2(box.corner_left.x-40,box.corner_left.y+50),40,0,4,1,20,1.25,0,true)
	bone_circle(Vector2(box.corner_right.x+40,box.corner_right.y+50),40,0,4,-1,20,-1.25,0,true)
	fs_gaster_blaster(Vector2(320,-30),Vector2(box.center.x,170),0)
	await get_tree().create_timer(0.5).timeout
	
	
	for i in 4:
		var y_pos = 150
		var xpos1 = box.corner_left.x + i*30
		var xpos2 = box.corner_right.x - i*30
		fs_gaster_blaster(Vector2(-20,0),Vector2(xpos1,y_pos),0,1,0)
		fs_gaster_blaster(Vector2(-20,0),Vector2(xpos2,y_pos),0,1,0)
		bone(Vector2(box.corner_bottom.x+60,320),2,30,Vector2(50,50),-3,0,true)
		bone(Vector2(box.corner_b_left.x-60,320),2,-30,Vector2(50,50),3,0,true)
		await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(1).timeout
	var twee2 = create_tween()
	twee2.set_parallel()
	twee2.tween_property(box,"xscale",200,0.75).set_trans(Tween.TRANS_SINE)
	twee2.tween_property(box,"yscale",0,0.75).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.5).timeout
	
	player.set_mode(PlayerSoul.MODE.BLUE)
	fs_gaster_blaster(Vector2(640,320),box.corner_bottom,90,0.7,0,0,5,8)
	await get_tree().create_timer(0.25).timeout
	var posi = box.center-Vector2(0,85)
	var typ = 0
	var a = bone(posi-Vector2(0,30),typ,0,Vector2(0,0),0,0,true)
	var tw = create_tween()
	tw.tween_property(a,"offset_down",140,.75).set_trans(Tween.TRANS_BOUNCE)
	Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
	
	var bons = bone_stab(box.corner_right+Vector2(0,-5),0,180,42,20,15,440)
	bons.up_down()
	for i in 10:
		if i < 5:
			_3sBone(box.corner_b_left-Vector2(20,15),10,3)
		else:
			_3sBone(box.corner_bottom+Vector2(20,-15),10,-3)
		for x in 2:
			var dir = 1 if x==0 else -1
			var _type = int(i%2==0)+1
			var aa = bone(posi-Vector2(0,30),_type,0,Vector2(0,0),0,0,true)
			var twe = create_tween()
			twe.tween_property(aa,"offset_down",140,.5).set_trans(Tween.TRANS_SINE)
			twe.tween_property(aa,"xspeed",3*dir,0.5).set_trans(Tween.TRANS_SINE)
	
		await get_tree().create_timer(0.75).timeout
		
	var twe = create_tween()
	twe.set_parallel()
	twe.tween_property(a,"position:y",-200,0.5).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(box,"xscale",400,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"right",true)
	bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,30,10,200)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"left",true)
	bone_stab(box.corner_left-Vector2(10,0),0,90,12,30,10,200)
	fs_gaster_blaster(Vector2.ZERO,box.center-Vector2(150,0),-90,1,0,0,0,8)
	fs_gaster_blaster(Vector2(640,0),box.corner_right-Vector2(15,-20),90,1,0,25,5,8)
	fs_gaster_blaster(Vector2(640,0),box.corner_bottom-Vector2(15,20),90,1,0,25,5,8)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.RED)
	bone(box.center-Vector2(220,-40),1,0,Vector2(140,0),10,0,true)
	bone(box.center-Vector2(-220,-40),1,0,Vector2(140,0),-10,0,true)
	await get_tree().create_timer(1).timeout
	attacks_manager.attack_end()

func _3sBone(_pos:Vector2,_angle:float,xspd=3):
	for i in 3:
		sine_bone(_pos,_angle).xspeed = xspd
		await get_tree().create_timer(0.05).timeout

func sine_bone(_pos:Vector2,angle:float,_ini:float=15,fin:float=35):
	var bbon = bone(_pos,0,angle,Vector2(_ini,0),0,0,true)
	var twe = create_tween()
	twe.set_loops(25)
	twe.tween_property(bbon,"offset_top",fin,0.35).set_trans(Tween.TRANS_SINE)
	twe.tween_property(bbon,"offset_top",_ini,0.35).set_trans(Tween.TRANS_SINE)
	return bbon

func bone_appear2(_pos:Vector2,_to:float=40,_size:float = 40,_type:int=0,_angle:float=0):
	var node : Bullet = Bullet.new()
	node.masked = true
	node.position = _pos
	node.rotation_degrees = _angle
	mask.add_child(node)
	
	for i in 20:
		var bon = attacks_manager.get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
		bon.position = Vector2(i*15,0)
		bon.type = _type
		bon.offset_down = _size
		node.add_child(bon)
		var twe = create_tween()
		twe.tween_property(bon,"position:y",-_to*2,0.15).as_relative().set_trans(Tween.TRANS_SINE)
		twe.tween_property(bon,"position:y",_to,0.15).as_relative().set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.025).timeout
	await get_tree().create_timer(0.5).timeout
	node.queue_free()


func attack_finished():
	pass

