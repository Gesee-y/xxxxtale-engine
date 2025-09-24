extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,-15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.BLUE,"up",true)
	bone_stab(box.corner_right+Vector2(0,-5),0,180,30,30,15,530)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,30,15,500)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.RED)
	for i in 5:
		var height : float = 50 if i % 2 == 0 else 60
		var height2 : float = 50 if i % 2 == 1 else 60
		var t1 = 0 if i%2==0 else 2
		var t2 = 1 if i%2==0 else 0
		bone(box.corner_right+Vector2(50,0),t1,0,Vector2(0,height),-3,0,true)
		bone(box.corner_b_left-Vector2(50,0),t2,0,Vector2(height2+8,0),3,0,true)
		await get_tree().create_timer(0.3).timeout
	
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"right")
	var plate = plateform(Vector2(box.corner_right.x+30,345),0,-90,50,Vector2.ZERO)
	create_tween().tween_property(plate,"position:x",box.corner_right.x-40,0.75).set_trans(Tween.TRANS_SINE)
	bone_appear(box.corner_bottom+Vector2(45,0),40,40,0,-90)
	await get_tree().create_timer(0.75).timeout
	var up = Vector2.UP*15
	for i in 5:
		bone(box.corner_right-Vector2(20,20)+up,0,90,Vector2(0,35),0,4,true)
		bone(box.corner_bottom+Vector2(-20,20)+up,0,90,Vector2(0,35),0,-4,true)
		bone(Vector2(box.corner_left.x,box.corner_right.y)-Vector2(-35,45)+up,
				0,90,Vector2(0,80),0,4,true)
		bone(box.corner_b_left+Vector2(35,-5)+up,0,90,Vector2(0,80),0,-4,true)
		await get_tree().create_timer(0.5).timeout
	bone(box.corner_right-Vector2(40,40)+up,0,90,Vector2(0,55),0,4,true)
	bone(box.corner_bottom+Vector2(-40,20)+up,0,90,Vector2(0,55),0,-4,true)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"left",true)
	bone_appear2(box.corner_left-Vector2(65,0),40,40,0,90)
	fs_gaster_blaster(Vector2.ZERO,Vector2(200,150),angle_to_target(Vector2(200,150),Vector2(box.corner_left.x+20,320)),0.7,
			0,0,5,12)
	fs_gaster_blaster(Vector2(0,480),Vector2(200,150+320),angle_to_target(Vector2(200,150+320),Vector2(box.corner_left.x+20,320)),0.7,
			0,0,5,12)
	await get_tree().create_timer(1).timeout
	attacks_manager.attack_end()

func bone_appear(_pos:Vector2,_to:float=40,_size:float = 40,_type:int=0,_angle:float=0):
	var node : Bullet = Bullet.new()
	node.masked = true
	node.position = _pos
	node.rotation_degrees = _angle
	mask.add_child(node)
	
	for i in 15:
		var bon = attacks_manager.get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
		bon.position = Vector2(i*15,0)
		bon.type = _type
		bon.offset_down = _size
		node.add_child(bon)
		create_tween().tween_property(bon,"position:y",-_to,0.25).as_relative().set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.05).timeout

func bone_appear2(_pos:Vector2,_to:float=40,_size:float = 40,_type:int=0,_angle:float=0):
	var node : Bullet = Bullet.new()
	node.masked = true
	node.position = _pos
	node.rotation_degrees = _angle
	mask.add_child(node)
	
	for i in 15:
		var bon = attacks_manager.get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
		bon.position = Vector2(i*15,0)
		bon.type = _type
		bon.offset_down = _size
		node.add_child(bon)
		var twe = create_tween()
		twe.tween_property(bon,"position:y",-_to*2,0.25).as_relative().set_trans(Tween.TRANS_SINE)
		twe.tween_property(bon,"position:y",_to,0.25).as_relative().set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.05).timeout

func attack_finished():
	pass

