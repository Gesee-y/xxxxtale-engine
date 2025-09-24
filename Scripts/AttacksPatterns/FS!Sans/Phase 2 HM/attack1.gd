extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(200,-15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.RED)
	for i in 30:
		var rnd = randf()
		var rnd2 = randf()
		var bone_pos = box.corner_b_left.lerp(box.corner_bottom,rnd)
		var bone_pos2 = box.corner_bottom.lerp(box.corner_right,rnd2)
		
		var b = bone(bone_pos,0,0,Vector2(5,5),0,0,true)
		var b2 = bone(bone_pos2,0,90,Vector2(5,5),0,0,true)
		
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(b,"position:y",20,0.5).as_relative().set_trans(Tween.TRANS_SINE)
		tween.tween_property(b2,"position:x",20,0.5).as_relative().set_trans(Tween.TRANS_SINE)
		
		tween.chain()
		tween.tween_property(b,"position:y",-600,4).as_relative().set_trans(Tween.TRANS_SINE)
		tween.tween_property(b2,"position:x",-600,4).as_relative().set_trans(Tween.TRANS_SINE)
		
		if i % 4 == 1:
			var off = Vector2(400,0)
			bone(box.center-off,2,0,Vector2(160,160),10,0,true) # Left Orange Bone
			bone(box.center+off,2,0,Vector2(160,160),-10,0,true) # Right Orange Bone
		elif i % 4 == 3:
			var off = Vector2(0,200)
			bone(box.center-off,2,90,Vector2(160,160),0,10,true) # Up Orange Bone
			bone(box.center+off,2,90,Vector2(160,160),0,-10,true) # Down Orange Bone
		
		if i % 3 == 0:
			var _pos = Vector2(randi_range(100,500),randi_range(150,400))
			var start_pos = Vector2([randi_range(-100,-20),randi_range(660,740)].pick_random(),
					[randi_range(-100,-20),randi_range(500,600)].pick_random())
			var _ang = angle_to_target(_pos,player.global_position)
			
			fs_gaster_blaster(start_pos,_pos,_ang,0.5,0)
		
		await get_tree().create_timer(0.2).timeout
	
	create_tween().tween_property(box,"xscale",400,1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.8).timeout
	
	var siner : float = 0
	for i in 15:
		var b1 = bone(box.corner_right+Vector2(50,0),0,0,Vector2(0,(30)+sin(siner)*20),0,0,true)
		var b2 = bone(box.corner_bottom+Vector2(50,0),0,0,Vector2((30)-sin(siner)*20,0),0,0,true)
		
		boomerang(b1,"position:x",b1.position.x,box.corner_left.x,1.5)
		boomerang(b2,"position:x",b2.position.x,box.corner_left.x,1.5)
		siner += PI/10.0
		await get_tree().create_timer(0.1).timeout
	
	for i in 5:
		bone(box.corner_left+Vector2(-30,-40),int(i>2)+1,45,Vector2(100,100),7,4,true)
		
		# The white bones
		bone(Vector2(box.corner_left.x,100),0,90,Vector2(0,50),0,10,true)
		bone(Vector2(box.corner_right.x,400),0,-90,Vector2(0,50),0,-10,true)
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(0.5).timeout
	
	for i in 4:
		var dir = ["up","down","left","right"].pick_random()
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
		bone(box.center-off,int(dir!="left")+1,0,Vector2(60,60),12,0,true) # Left Orange Bone
		bone(box.center+off,int(dir!="right")+1,0,Vector2(60,60),-12,0,true) # Right Orange Bone
		bone(box.center-off2,int(dir!="up")+1,90,Vector2(60,60),0,12,true) # Up Orange Bone
		bone(box.center+off2,int(dir!="down")+1,90,Vector2(60,60),0,-12,true) # Down Orange Bone
		
		await get_tree().create_timer(0.82).timeout
	await get_tree().create_timer(0.75).timeout
	
	attacks_manager.attack_end()

func attack_finished():
	pass

