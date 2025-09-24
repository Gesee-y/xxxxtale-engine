extends AttackPattern

var plate
var d : int = 0

func _ready():
	box_pre = Vector2(400,-15)

func pre_attack():
	pass

func main_attack():
	var twee2 = create_tween()
	twee2.tween_property(box,"xscale",540,0.25).set_trans(Tween.TRANS_SINE)
	player.set_mode(PlayerSoul.MODE.BLUE,"up",true)
	bone_stab(box.corner_right+Vector2(0,-10),0,180,30,30,5,30)
	fs_gaster_blaster(Vector2.ZERO,Vector2(320,150),0,1,0,0,1)
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	bone_appear(box.corner_b_left-Vector2(230,-30),40,20,0,0)
	var bh = bone(box.corner_b_left+Vector2(200,150),0,90,Vector2(0,230),0,0,true)
	boomerang(bh,"position:y",box.corner_b_left.y+150,box.corner_left.y+35,1)
	var twee = create_tween()
	twee.tween_property(box,"xscale",100,0.5).set_trans(Tween.TRANS_SINE)
	var _loop : int =0
	while _loop < 3:
		match _loop:
			0:
				plateform(Vector2(200,340),0,0,50,Vector2(1,0),true)
				bone(Vector2(450,440),0,0,Vector2(150,0),-1,0,true)
				b3_d(box.corner_right+Vector2(250,0))
				boomerang_wall(box.center-Vector2(250,10),box.center+Vector2(200,-10),Vector2(2,1))
				bone(Vector2(50,420),0,0,Vector2(90,0),3,0,true)
				
				await get_tree().create_timer(1.5).timeout
				fs_gaster_blaster(Vector2(660,0),box.corner_right-Vector2(15,0),0,1,0)
				fs_gaster_blaster(Vector2(660,0),box.corner_right-Vector2(50,0),0,1,0,9)
				plate = plateform(Vector2(660,290),0,0,50,Vector2(-2,0))
				plate.connect("on_plateform",func():
							if d%2==0:
								var b = bone(box.corner_left+Vector2(200,-150),2,90,Vector2(0,230),0,0,false)
								boomerang(b,"position:y",box.corner_left.y-150,box.corner_left.y-35,1)
				)
				await get_tree().create_timer(0.5).timeout
				bone_cross(Vector2(-20,330),2.5,0,50,3)
				await get_tree().create_timer(0.5).timeout
				fs_gaster_blaster(Vector2(680,320),Vector2(500,340),90,1,0,2,1)
				
				await get_tree().create_timer(2).timeout
				var twe = create_tween()
				twe.set_parallel()
				twe.tween_property(plate,"position:y",200,1).as_relative().set_trans(Tween.TRANS_SINE)
				twe.tween_property(plate,"rotation_degrees",150,1).as_relative().set_trans(Tween.TRANS_SINE)
				
				player.set_mode(PlayerSoul.MODE.BLUE,"up",true)
				var bb = styled_bone_stab(box.corner_right-Vector2(0,20),0,180,32,30,5,550)
				
				plateform(Vector2(0,340),0,0,40,Vector2(4,0))
				plateform(Vector2(640,340),0,0,40,Vector2(-4,0))
				bone(Vector2(50,420),0,0,Vector2(75,0),4,0,true)
				bone(Vector2(580,420),0,0,Vector2(75,0),-4,0,true)
				await get_tree().create_timer(0.5).timeout
				plateform(Vector2(0,340),0,0,40,Vector2(4,0))
				plateform(Vector2(640,340),0,0,40,Vector2(-4,0))
				bone(Vector2(50,420),0,0,Vector2(78,0),4,0,true)
				bone(Vector2(580,420),0,0,Vector2(78,0),-4,0,true)
				plate.queue_free()
				await get_tree().create_timer(0.3).timeout
				player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
				do(bb)
				
			1:
				for i in 10:
					for x in 5:
						var rnd = RandomNumberGenerator.new()
						rnd.randomize()
						var _pos = Vector2(rnd.randi_range(80,560),150+rnd.randf_range(-30,30))
						bone_cross(_pos,2,2,rnd.randi_range(10,20),0,4)
					
					plateform(Vector2(0,340),0,0,40,Vector2(3,0))
					plateform(Vector2(640,340),0,0,40,Vector2(-3,0))
					bone(Vector2(50,420),0,0,Vector2(80,0),3,0,true)
					bone(Vector2(580,420),0,0,Vector2(80,0),-3,0,true)
					await get_tree().create_timer(0.75).timeout
				
			
		_loop += 1
		
	await get_tree().create_timer(1).timeout
	attacks_manager.attack_end() 

func attack_finished():
	pass

func do(bb):
	for i in bb.bones.get_child_count():
		if i <5 or i > 27:
			var b =  bb.bones.get_child(i)
			var twed = create_tween()
			twed.set_parallel()
			twed.tween_property(b,"offset_top",45,1).as_relative().set_trans(Tween.TRANS_SINE)
			twed.tween_property(b,"position:y",-17,1).as_relative().set_trans(Tween.TRANS_SINE)
			await get_tree().create_timer(0.05).timeout

func b3_d(_pos:Vector2,_init:float=10,_to:float = 40):
	for i in 4:
		var bo = bone(_pos,0,0,Vector2(0,_init),-1.5,0,true)
		var del = func():
			await get_tree().create_timer(2).timeout
			create_tween().tween_property(bo,"position:y",-50,0.75).as_relative().set_trans(Tween.TRANS_SINE)
		create_tween().tween_property(bo,"offset_down",_to,0.5).set_trans(Tween.TRANS_SINE).finished.connect(del)
		await get_tree().create_timer(0.3).timeout
		

func bone_cross(_pos : Vector2,_ang_spd:float=2,_type:int = 0,_size:float=40,
		_xspd:float=0,_yspd:float=0,_hide:bool = true):
	var b1 = bone(_pos,_type,0,Vector2(_size,_size),_xspd,_yspd,_hide)
	var b2 = bone(_pos,_type,90,Vector2(_size,_size),_xspd,_yspd,_hide)
	b1.ang_spd = _ang_spd
	b2.ang_spd = _ang_spd

func bone_appear(_pos:Vector2,_to:float=40,_size:float = 40,_type:int=0,_angle:float=0,_count:int=40):
	var node : Bullet = Bullet.new()
	node.masked = true
	node.position = _pos
	node.rotation_degrees = _angle
	mask.add_child(node)
	
	for i in _count:
		var bon = attacks_manager.get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
		bon.position = Vector2(i*15,0)
		bon.type = _type
		bon.offset_down = _size
		node.add_child(bon)
		create_tween().tween_property(bon,"position:y",-_to,0.25).as_relative().set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.025).timeout

func bone_appear2(_pos:Vector2,_to:float=40,_size:float = 40,_type:int=0,_angle:float=0,_count:int=40):
	var node : Bullet = Bullet.new()
	node.masked = true
	node.position = _pos
	node.rotation_degrees = _angle
	mask.add_child(node)
	
	for i in _count:
		var bon = attacks_manager.get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
		bon.position = Vector2(-i*15,0)
		bon.type = _type
		bon.offset_down = _size
		node.add_child(bon)
		create_tween().tween_property(bon,"position:y",-_to,0.25).as_relative().set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.025).timeout

func boomerang_wall(_pos:Vector2,_to:Vector2,_type:Vector2):
	for i in 4:
		var bo = bone(_pos,_type.x,0,Vector2(45,45),0,0,true)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(bo,"position",_to,1.5).set_trans(Tween.TRANS_SINE)
		tween.chain()
		tween.tween_property(bo,"type",_type.y,0.5)
		tween.tween_property(bo,"position",_pos,1.5).set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.05).timeout

func styled_bone_stab(_pos:Vector2,_type:int,_angle:float,_count:int = 12,_height:float=30,_wait:float = 15,_hold:float=30,_delay:int=2,_gaps:float = 5,_alert:bool = true):
	var i = bone_stab(_pos,_type,_angle,_count,_height,_wait,_hold,_gaps,_alert,3)
	i.delay = _delay
	return i
