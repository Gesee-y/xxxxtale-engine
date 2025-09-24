extends AttackPattern

var can_scroll : bool = false
var scroll_spd = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if can_scroll:
		main.back_layer.position.y -= scroll_spd
		main.back_layer.size.y += scroll_spd

func pre_attack():
	box.set_form("circle")

func main_attack():
	var twe = create_tween()
	var cir = bone_circle(box.center,120,0,12,4,55,0,0,true)
	var cir2 = bone_circle(box.center,120,1,3,-1,40,0,0,true)
	twe.set_parallel()
	twe.tween_property(cir,"radius",60,0.5).set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir2,"radius",43,0.5).set_trans(Tween.TRANS_SINE)
	twe.tween_property(box,"xpos",-200,3).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir,"position:x",-200,3).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir2,"position:x",-200,3).as_relative().set_trans(Tween.TRANS_SINE)
	twe.chain()
	twe.tween_property(cir,"radius",80,1).set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir2,"radius",40,1).set_trans(Tween.TRANS_SINE)
	twe.tween_property(box,"xpos",200,5).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir,"position:x",200,5).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir2,"position:x",200,5).as_relative().set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(3).timeout
	cir2.type = 2
	#await get_tree().create_timer(5).timeout
	await get_tree().create_timer(0.5).timeout
	fs_gaster_blaster(Vector2(800,box.center.y-60),Vector2(box.center.x+200,box.center.y-60),90,0.7,0,5,1)
	fs_gaster_blaster(Vector2(800,box.center.y-60),Vector2(box.center.x+200,box.center.y+60),90,0.7,0,5,1)
	await get_tree().create_timer(1).timeout
	fs_gaster_blaster(Vector2(800,box.center.y),Vector2(box.center.x+200,box.center.y),90,0.7,0,5,1)
	await get_tree().create_timer(0.5).timeout
	for i in 5:
		bone_cross(box.center+Vector2(200,40),2,1,20,-4,0,true)
		bone_cross(box.center-Vector2(200,40),2,1,20,4,0,true)
		await get_tree().create_timer(3.0/5.0).timeout
	
	cir2.type = 1
	for i in 10:
		bone_cross(box.center+Vector2(30,200),2,2,20,0,-4)
		bone_cross(box.center-Vector2(30,200),-2,2,20,0,4)
		await get_tree().create_timer(0.5).timeout
	
	cir2.type = 2
	for i in 5:
		randomize()
		var start = Vector2(randi_range(0,640),-80)
		var end = Vector2(randi_range(100,540),100)
		fs_gaster_blaster(start,end,angle_to_target(end,player.global_position),.5,0)
		await get_tree().create_timer(0.5).timeout
	Global.display.click(0.5)
	await get_tree().create_timer(0.25).timeout
	clear_attack(true)
	box.set_form("rect",1/2.0)
	await get_tree().create_timer(0.15).timeout
	box.yscale = -390
	box.xpos = -100
	box.ypos = -90
	can_scroll = true
	player.variety = 1
	await get_tree().create_timer(0.1).timeout
	player.position = box.center
	
	for i in 10:
		var rnd_pos = Vector2(randf_range(box.corner_left.x,box.corner_right.x),0)
		var rnd_ang = randi_range(-30,30)
		var spd = 4
		bone(rnd_pos,0,rnd_ang,Vector2(10,10),cos(deg_to_rad(rnd_ang+90))*spd,sin(deg_to_rad(rnd_ang+90))*spd,true)
		bone(Vector2(randi_range(box.corner_b_left.x,box.corner_bottom.x),600),
				0,0,Vector2(0,30),0,-13,true)
		await get_tree().create_timer(0.2).timeout
	
	var siner : float = 0
	for i in 120:
		var amp = 50
		siner += PI/20.0
		if i % 30 != 0:
			bone(Vector2(box.corner_left.x+15,600),0,90,Vector2(0,60+sin(siner)*amp),0,-10,true)
			bone(Vector2(box.corner_right.x-15,600),0,-90,Vector2(0,60+sin(-siner)*amp),0,-10,true)
			await get_tree().create_timer(0.025).timeout
		elif i != 0:
			siner = randi_range(-PI,PI)
			await get_tree().create_timer(0.5).timeout
	
	var bon = bone_stab(Vector2(box.corner_right.x,-10),0,180,12,30,0,700)
	bon.sine_fx(30,0.25)
	
	for i in 100:
		if i % 20 == 0:
			var bo = bone(Vector2(box.corner_right.x-70,600),0,90,Vector2(0,80),0,-13,true)
			create_tween().tween_property(bo,"position:x",50,1.5-(i/100.0)).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		if i % 20 == 10:
			var bo = bone(Vector2(box.corner_left.x+70,600),0,-90,Vector2(0,80),0,-13,true)
			create_tween().tween_property(bo,"position:x",-50,1.5-(i/100.0)).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		bone(Vector2(box.corner_left.x,600),0,90+20,Vector2(0,10+i),0,-10,true)
		bone(Vector2(box.corner_right.x,600),0,-90-20,Vector2(0,10+i),0,-10,true)
		await get_tree().create_timer(0.025).timeout
	await get_tree().create_timer(0.025).timeout
	var twe3 = create_tween()
	twe3.tween_property(box,"ypos",-60,0.5).as_relative()
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	bone_stab(box.corner_b_left+Vector2(0,5),0,0,30,30,15,500)
	await get_tree().create_timer(0.75).timeout
	Global.display.click(0.5)
	await get_tree().create_timer(0.25).timeout
	box.yscale = -10
	box.xpos = 0
	box.ypos = 0
	can_scroll = false
	main.back_layer.position.y=0
	main.back_layer.size.y = 480
	clear_attack()
	await get_tree().create_timer(0.1).timeout
	player.last = box.center-Vector2(0,40)
	player.position = box.center-Vector2(0,40)
	bone_stab(box.corner_b_left+Vector2(0,5),0,0,20,20,15,500)
	plateform(box.center+Vector2(-60,0),0,0,40,Vector2.ZERO,true)
	plateform(box.center+Vector2(20,0),0,0,40,Vector2.ZERO,true)
	bone(Vector2(box.center+Vector2(0,10)),
		0,0,Vector2(0,85-25),0,0,true)
	bone_circle(Vector2(box.corner_left.x+40,box.corner_left.y+50),30,2,4,2,20,0,0,true)
	bone_circle(Vector2(box.corner_right.x-40,box.corner_right.y+50),30,2,4,-2,20,0,0,true)
	await get_tree().create_timer(0.15).timeout
	player.set_mode(PlayerSoul.MODE.BLUE)
	Global.players[0].hp += 40
	for i in 5:
		var start = Vector2(randi_range(0,640),-80)
		var end = Vector2(randi_range(100,540),100)
		fs_gaster_blaster(start,end,angle_to_target(end,player.global_position),.5,1,0,0)
		if i %2==0:
			fs_gaster_blaster(Vector2(0,-30),Vector2(box.center.x-40,150),0,1,0,0,0,4)
		else:
			fs_gaster_blaster(Vector2(640,-30),Vector2(box.center.x+40,150),0,1,0,0,0,4)
		await get_tree().create_timer(0.8).timeout
	Global.display.click(0.5)
	await get_tree().create_timer(0.25).timeout
	box.set_form("circle",1/2.0)
	clear_attack(true)
	await get_tree().create_timer(0.1).timeout
	player.position = box.center
	player.set_mode(PlayerSoul.MODE.RED)
	await get_tree().create_timer(0.15).timeout
	var p = bone_polygon(box.center,60,0,12,-2,0,0,true)
	await get_tree().create_timer(0.1).timeout
	
	var b = bone(box.center+Vector2(1.5,-5),1,0,Vector2.ZERO,0,0,true)
	b.ang_spd = 3
	var twe2 = create_tween()
	twe2.set_parallel()
	twe2.tween_property(b,"offset_top",30,1).set_trans(Tween.TRANS_SINE)
	twe2.tween_property(b,"offset_down",30,1).set_trans(Tween.TRANS_SINE)
	
	for i in 80:
		var pos = box.center+to_cartesian_from_polar(150,PI/15.0*i)
		fs_gaster_blaster(pos-to_cartesian_from_polar(150,PI/15.0*i)*5,
				pos,rad_to_deg(PI/15.0*i+PI/2.0),0.75)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(2).timeout
	attacks_manager.attack_end()

#func attack_finished():
	#main.enemy_manager.enemies[0].mode="hit"

func to_cartesian_from_polar(_radius:float,_angle:float):
	var x = _radius * cos(_angle)
	var y = _radius * sin(_angle)
	return Vector2(x,y)

func bone_cross(_pos : Vector2,_ang_spd:float=2,_type:int = 0,_size:float=40,
		_xspd:float=0,_yspd:float=0,_hide:bool = true):
	var b1 = bone(_pos,_type,0,Vector2(_size,_size),_xspd,_yspd,_hide)
	var b2 = bone(_pos,_type,90,Vector2(_size,_size),_xspd,_yspd,_hide)
	b1.ang_spd = _ang_spd
	b2.ang_spd = _ang_spd
