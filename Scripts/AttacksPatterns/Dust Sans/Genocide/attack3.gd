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
	player.set_mode(PlayerSoul.MODE.RED)
	var pos : Array[Vector2] = []
	var t : Array[float] = []
	var precision = 50
	var dis = 200
	var mul = 12
	for i in precision:
		var ang = (TAU/float(precision))*i
		var d = cos(ang*5) * dis
		
		pos.append(box.center + to_cartesian_from_polar(d,ang))
		t.append((i/float(precision))*mul)
	
	for i in 10:
		dust_gaster_blaster(Vector2(-20,0),Vector2(100,100),0-i*10,0.5,0,0,0,4)
		
		if i % 2 == 0:
			var xpos = i * 30
			var ypos = 100 + i * 20
			var st_pos = Vector2(xpos,480)
			var tang : Array[Vector2] = []
			var sp : Bullet = spear(st_pos,0,0,false)
			sp.interp_rotation = true
			sp.free_on_contact = false
			sp.interpolate(Bullet.STYLE.KCURVE,2,precision,pos,t,tang,Vector3(0.5,0.2,-0.4))
		await get_tree().create_timer(0.1).timeout
	
	for i in 10:
		dust_gaster_blaster(Vector2(660,0),Vector2(540,100),0+i*10,0.5,0,0,0,4)
		
		if i % 2 == 0:
			var xpos = 640 - i * 30
			var ypos = 100 + i * 20
			var st_pos = Vector2(xpos,480)
			var tang : Array[Vector2] = []
			var sp : Bullet = spear(st_pos,0,0,false)
			sp.interp_rotation = true
			sp.free_on_contact = false
			sp.interpolate(Bullet.STYLE.KCURVE,2,precision,pos,t,tang,Vector3(0.5,0.2,-0.4))
		await get_tree().create_timer(0.1).timeout
	
	for i in 5:
		var start = Vector2(0,-100)
		var end = Vector2(20+i*90,100)
		var start2 = Vector2(0,100)
		var end2 = Vector2(640-i*90,100)
		dust_gaster_blaster(start,end,-45,.5,0,0,0,5)
		dust_gaster_blaster(start2,end2,45,.5,0,0,0,5)
	
	await get_tree().create_timer(1.5).timeout
	Global.display.click(0.5)
	var sans = main.enemy_manager.enemies[0]
	var b_pos = Vector2(sans.xpos,sans.ypos)
	await get_tree().create_timer(0.25).timeout
	box.xpos = 100
	box.ypos = -100
	
	sans.xpos = 150
	sans.ypos = 240
	clear_attack(true)
	player.position = box.center
	await get_tree().create_timer(0.15).timeout
	player.position = box.center
	player.shield_locked = true
	
	var cr_spd = 2
	var c_spd = 4
	var rad = 70
	var siz = 70
	
	var node = Bullet.new()
	node.position = box.center
	attacks_manager.mask.add_child(node)
	create_tween().tween_property(node,"rotation_degrees",360*10,12)
	var gap = 60
	var gap2 = 90
	var posi = [Vector2(gap,0),Vector2(-gap,0),Vector2(0,gap),Vector2(0,-gap)]
	var posi2 = [Vector2(gap2,0),Vector2(-gap2,0),Vector2(0,gap2),Vector2(0,-gap2)]
	var dur = 0.75
	
	for i in 4:
		var _size = 7
		var b = bone(posi[i],2,0,Vector2(_size,_size),0,0,true,false)
		var b2 = bone(posi[i],2,0,Vector2(_size,_size),0,0,true,false)
		b.ang_spd = 6
		b2.ang_spd = 6
		b.angle = 90*i
		b2.angle = 90*i+90
		node.add_child(b)
		node.add_child(b2)
		var property = "position:x" if i < 2 else "position:y"
		
		var tt = create_tween()
		tt.set_loops(6)
		tt.set_parallel()
		tt.tween_property(b,"position",Vector2.ZERO,dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tt.tween_property(b2,"position",Vector2.ZERO,dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tt.chain()
		tt.tween_property(b,"position",posi[i],dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tt.tween_property(b2,"position",posi[i],dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tt.chain()
		tt.tween_property(b,"position",Vector2.ZERO,dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tt.tween_property(b2,"position",Vector2.ZERO,dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tt.chain()
		tt.tween_property(b,"position",posi2[i],dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tt.tween_property(b2,"position",posi2[i],dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
	
	var c1 = bone_circle(box.center,rad,-1,c_spd,3,siz,0,0,true)
	for c in c1.bones.get_children():
		c.angle -= 90
		c.ang_spd = cr_spd
		c.custom_color = Color.PURPLE
	
	var c2 = bone_circle(box.center,rad,-1,c_spd,3,siz,0,0,true)
	for c in c2.bones.get_children():
		c.custom_color = Color.PURPLE
		c.angle -= 0
		c.ang_spd = cr_spd
	
	var c3
	for i in 15:
		var spd = 2
		bone(box.corner_left+Vector2(40,-25),0,45,Vector2(40,40),0,spd,true)
		bone(box.corner_bottom+Vector2(-40,25),0,45,Vector2(40,40),0,-spd,true)
		
		var off = Vector2(200,0)
		bone(box.center+off,2,0,Vector2(60,60),-12,0,true) # Right Orange Bone
		if i == 2 :
			box.bg.color = Color.PURPLE
		
		if i == 10:
			c3 = bone_circle(box.center,150,-1,20,0,100,0,0,true)
			for c in c3.bones.get_children():
				c.angle -= randi_range(-20,20)
				c.custom_color = Color.PURPLE
			
			var c4 = bone_circle(box.center,120,-1,20,0,100,0,0,true)
			for c in c4.bones.get_children():
				c.angle -= randi_range(-20,20) + 20
				c.custom_color = Color.PURPLE
				
			await get_tree().create_timer(0.05).timeout
			box.bg.color = Color.BLACK
			c1.queue_free()
			c2.queue_free()
			create_tween().tween_property(c3,"radius",-60,5).as_relative().set_trans(Tween.TRANS_SINE)
		
		await get_tree().create_timer(0.75).timeout
		
	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(sans,"xpos",b_pos.x,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sans,"ypos",b_pos.y,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	attacks_manager.attack_end()

func attack_finished():
	pass

func to_cartesian_from_polar(_radius:float,_angle:float):
	var x = _radius * cos(_angle)
	var y = _radius * sin(_angle)
	return Vector2(x,y)
