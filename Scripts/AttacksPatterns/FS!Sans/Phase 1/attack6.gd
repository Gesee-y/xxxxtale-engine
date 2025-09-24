extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,-10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
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
		
		await get_tree().create_timer(0.82).timeout
	
	player.set_mode(PlayerSoul.MODE.RED)
	var cir = bone_circle(box.center+Vector2(-3,0),150,0,4,2,30,0,0,true)
	var twe = create_tween()
	twe.set_parallel()
	twe.tween_property(cir,"radius",30,1).set_trans(Tween.TRANS_SINE)
	for i in 4:
		var start = Vector2(randi_range(0,640),-80)
		var end = Vector2(randi_range(100,540),100)
		fs_gaster_blaster(start,end,angle_to_target(end,player.global_position),.6,0)
		await get_tree().create_timer(0.5).timeout
	var p = bone_polygon(box.center,150,0,10,-2,0,0,true)
	create_tween().tween_property(p,"radius",50,0.75).set_trans(Tween.TRANS_SINE)
	for i in 8:
		if i % 2 == 0:
			bone_polygon(box.corner_bottom+Vector2(-30,20),8,2,5,1,0,-3,true)
			bone_polygon(box.corner_left-Vector2(-30,20),8,1,5,1,0,3,true)
		else:
			bone_polygon(box.corner_bottom+Vector2(30,-30),8,2,5,1,-3,0,true)
			bone_polygon(box.corner_left-Vector2(30,-30),8,1,5,1,3,0,true)
		await get_tree().create_timer(0.75).timeout
	await get_tree().create_timer(0.25).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

