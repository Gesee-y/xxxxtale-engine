extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(430,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	for i in 3:
		var gap = 10
		var idx = i -1
		var pos = box.center + Vector2(0,-100)
		
		var b1 = bone(pos+Vector2(gap*idx,0),0,0,Vector2(1,1),0,0,true)
		
		var tween = create_tween()
		tween.tween_property(b1,"offset_down",130,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
		get_tree().create_timer(0.5).timeout.connect(
			func():
				main.camera.shake=6
				Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg")
		)
		var disappear = func():
			var twe = create_tween()
			b1.type = 1 if idx == -1 else 0
			b1.type = 2 if idx == 1 else b1.type
			b1.set_piv_pos = false
			if idx != 0:
				var dur = 2
				twe.tween_property(b1,"position:x",50*idx,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				twe.tween_property(b1,"position:x",100*idx,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
				twe.finished.connect(b1.queue_free)
			else :
				await get_tree().create_timer(0.5).timeout
				var twe2 = create_tween()
				b1.type = 2
				twe2.tween_property(b1,"position:y",200,1).as_relative().set_trans(Tween.TRANS_SINE)
				twe2.finished.connect(b1.queue_free)
		
		#for i in 
		tween.finished.connect(disappear)
	
	var grinder_bone = func(pos:Vector2,wait=2,spd=0.5):
		var off = Vector2(0,200)
		var b1 = bone(pos-off,0,0,Vector2(1,1),0,0,true)
		var b2 = bone(pos+off,0,180,Vector2(1,1),0,0,true)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(b1,"offset_down",175,spd/2.0).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(b2,"offset_top",175,spd/2.0).set_trans(Tween.TRANS_BOUNCE)
		tween.chain()
		tween.tween_interval(wait)
		tween.tween_property(b1,"offset_down",1,spd/2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(b2,"offset_top",1,spd/2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
		Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
		get_tree().create_timer(spd/2.0).timeout.connect(func():Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg"))
	
	grinder_bone.call(Vector2(box.corner_right.x - 10,box.center.y),1.5)
	grinder_bone.call(Vector2(box.corner_right.x - 20,box.center.y),1.5)
	
	grinder_bone.call(Vector2(box.corner_left.x + 10,box.center.y),1.5)
	grinder_bone.call(Vector2(box.corner_left.x + 20,box.center.y),1.5)
	await get_tree().create_timer(0.3).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"down")
	var bc1 = bone_cross(box.corner_bottom+Vector2(10,-20),2,0,15,0,0,true)
	var bc2 = bone_cross(box.corner_left+Vector2(-10,20),-2,0,15,0,0,true)
	
	for i in bc1.size():
		boomerang(bc1[i],"position:x",bc1[i].position.x,box.corner_b_left.x,1).finished.connect(bc1[i].queue_free)
		boomerang(bc2[i],"position:x",bc2[i].position.x,box.corner_right.x,1).finished.connect(bc2[i].queue_free)
	
	for i in 3:
		var b1 = bone(box.center+Vector2(200,0),1,0,Vector2(40,0),-4,0,true)
		var b2 = bone(box.center+Vector2(-200,0),1,0,Vector2(40,0),4,0,true)
		
		boomerang(b1,"offset_top",40,90,0.3,5)
		boomerang(b1,"offset_down",40,90,0.3,5)
		boomerang(b2,"offset_top",40,90,0.3,5)
		boomerang(b2,"offset_down",40,90,0.3,5)
		
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(b1,"position:x",b2.position.x,1)
		tween.tween_property(b2,"position:x",b1.position.x,1)
		get_tree().create_timer(0.5).timeout.connect(func():
														b1.type = 2
														b2.type = 2)
		
		await get_tree().create_timer(0.15).timeout
	
	await get_tree().create_timer(0.25).timeout
	bone_cross(box.corner_left + Vector2(30,-50),2,0,20,0,4,true)
	bone_cross(box.corner_right + Vector2(-30,-50),2,0,20,0,4,true)
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(box,"xscale",500,0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(box,"yscale",-10,0.4).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(0.4).timeout
	var siner = 0.0
	var _size = 45
	player.set_mode(PlayerSoul.MODE.BLUE,"left",true)
	
	for i in 15:
		if i % 2 == 0:
			bone(box.corner_right+Vector2(50,0),0,0,Vector2(0,_size+sin(siner)*20),-8,0,true)
			bone(box.corner_bottom+Vector2(50,0),0,0,Vector2(_size-sin(siner)*20,0),-8,0,true)
		siner += PI/8.0
		await get_tree().create_timer(0.1).timeout
	
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	
	bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,20,10,5)
	bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,10,10,5)
	
	await get_tree().create_timer(0.75).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"left",true)
	
	bone_stab(box.corner_left-Vector2(10,0),0,90,12,10,10,5)
	
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"right",true)
	
	bone_stab(box.corner_left-Vector2(10,0),0,90,12,10,10,5)
	bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,10,10,5)
	bone_stab(box.corner_right+Vector2(0,-5),0,180,30,50,10,5)
	
	await get_tree().create_timer(0.75).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"up",true)
	
	bone_stab(box.corner_right+Vector2(0,-5),0,180,30,20,10,5)
	bone_stab(box.corner_left-Vector2(10,0),0,90,12,10,10,5)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	
	create_tween().tween_property(box,"xscale",250,0.5).set_trans(Tween.TRANS_SINE)
	bone_cross(Vector2(box.center.x-100,box.corner_left.y),2,0,60,0,0,true)
	bone_cross(Vector2(box.center.x+100,box.corner_left.y),-2,0,60,0,0,true)
	var db1 = dust_gaster_blaster(Vector2(box.center.x+180,box.corner_bottom.y-25),Vector2(box.center.x+130,box.corner_bottom.y-25),90,1,0,0,0,10)
	var db2 = dust_gaster_blaster(Vector2(box.center.x-180,box.corner_bottom.y-25),Vector2(box.center.x-130,box.corner_bottom.y-25),-90,1,0,0,0,10)
	
	db1.masked = true
	db2.masked = true
	
	await get_tree().create_timer(1.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

func bone_cross(_pos : Vector2,_ang_spd:float=2,_type:int = 0,_size:float=40,
		_xspd:float=0,_yspd:float=0,_hide:bool = true):
	var b1 = bone(_pos,_type,0,Vector2(_size,_size),_xspd,_yspd,_hide)
	var b2 = bone(_pos,_type,90,Vector2(_size,_size),_xspd,_yspd,_hide)
	b1.ang_spd = _ang_spd
	b2.ang_spd = _ang_spd
	
	return [b1,b2]

