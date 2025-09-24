extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(500,-10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	create_tween().tween_property(box,"xscale",200,0.5).set_trans(Tween.TRANS_SINE)
	tornado()
	bone_cross(Vector2(box.center.x-100,box.corner_bottom.y),2,2,60,0,0,true)
	bone_cross(Vector2(box.center.x+100,box.corner_bottom.y),-2,2,60,0,0,true)
	
	bone_cross(Vector2(box.center.x-100,box.corner_left.y),2,1,60,0,0,true)
	bone_cross(Vector2(box.center.x+100,box.corner_left.y),-2,1,60,0,0,true)
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	var sprinkle_bone = func(pos:Vector2,direction:Vector2,dist=40,count=10,dur=1,rnd_type=false):
				for i in count:
					var gap = 15
					var dx = 1 if direction.y != 0 else 0
					var dy = 1 if direction.x != 0 else 0
					var rnd_y = sign(direction.y)*20
					var dir = Vector2(dx,dy)
					
					var rnd_pos = Vector2(randi_range(pos.x-dir.x*gap,pos.x+dir.x*gap),
							randi_range(pos.y-dir.y*gap,pos.y+dir.y*gap))
					
					
					
					var t = 0 if !rnd_type else randi_range(0,2)
					var base_ang = randi_range(-180,180)
					var ang = randi_range(-180,180)
					
					var b = bone(pos+dir*gap*i,t,direction.angle()+90,Vector2(3,3),0,0,true)
					var b2 = bone(pos-dir*gap*i,t,direction.angle()+90,Vector2(3,3),0,0,true)
					
					var tween = create_tween()
					tween.set_parallel()
					tween.tween_property(b,"position",b.position+direction*dist,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					tween.tween_property(b2,"position",b2.position+direction*dist,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					tween.chain()
					tween.tween_property(b,"position",pos+dir*gap*i,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
					tween.tween_property(b2,"position",pos-dir*gap*i,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
					
					#boomerang(b,"position",b.position,b.position+direction*dist,dur)
					#boomerang(b2,"position",b2.position,b2.position+direction*dist,dur)
					
					await get_tree().create_timer(0.1).timeout
	var dist = 80
	var cnt = 15
	var dur = 0.25
	var rnd_type = true
	
	get_tree().create_timer(0.35).timeout.connect(
			sprinkle_bone.bind(Vector2(box.center.x,box.corner_bottom.y+20),
					Vector2(0,-1),dist,cnt,dur,rnd_type))
	
	var redressing_bones = func(_spd=1):
				var Xoff = 30
				var eXoff = 30
				var siz = 40
				var b4 = bone(box.corner_bottom+Vector2(Xoff,0),-1,-45,Vector2(siz,0),0,0,true)
				var b5 = bone(box.corner_b_left-Vector2(Xoff,0),-1,45,Vector2(siz,0),0,0,true)
				var b6 = bone(box.corner_right+Vector2(Xoff,-10),-1,-45,Vector2(0,siz),0,0,true)
				var b7 = bone(box.corner_left-Vector2(Xoff,10),-1,45,Vector2(0,siz),0,0,true)
				b4.custom_color = Color.GREEN_YELLOW
				b5.custom_color = Color.GREEN_YELLOW
				b6.custom_color = Color.GREEN_YELLOW
				b7.custom_color = Color.GREEN_YELLOW
				
				var tween1 = create_tween()
				tween1.set_parallel()
				tween1.tween_property(b4,"position:x",box.corner_b_left.x-eXoff,_spd).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween1.tween_property(b5,"position:x",box.corner_bottom.x+eXoff,_spd).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween1.tween_property(b6,"position:x",box.corner_b_left.x-eXoff,_spd).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween1.tween_property(b7,"position:x",box.corner_bottom.x+eXoff,_spd).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween1.tween_property(b4,"angle",0,0.75).set_trans(Tween.TRANS_SINE)
				tween1.tween_property(b5,"angle",0,0.75).set_trans(Tween.TRANS_SINE)
				tween1.tween_property(b6,"angle",0,0.75).set_trans(Tween.TRANS_SINE)
				tween1.tween_property(b7,"angle",0,0.75).set_trans(Tween.TRANS_SINE)
				tween1.finished.connect(func():
											if b4 != null : b4.queue_free()
											if b5 != null : b5.queue_free()
											if b6 != null : b6.queue_free()
											if b7 != null : b7.queue_free())
	await get_tree().create_timer(0.25).timeout
	redressing_bones.call(0.5)
	await get_tree().create_timer(0.5).timeout
	#box.bg.color = Color.GREEN_YELLOW
	for i in 10:
		var Xoff = 100
		var eXoff = 30
		var siz = 50
		var spd = 4
		var bb = bone(box.corner_left-Vector2(Xoff*i,0),-1,45,Vector2(0,siz),spd,0,true)
		var bb2 = bone(box.corner_bottom+Vector2(Xoff*i,0),-1,-45,Vector2(siz,0),-spd,0,true)
		
		get_tree().create_timer(1.25).timeout.connect(
			func():
				var duration = 0.25
				var tween = create_tween()
				tween.set_parallel()
				if bb != null :tween.tween_property(bb,"angle",-45,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				if bb2 != null : tween.tween_property(bb2,"angle",45,duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		)
	await get_tree().create_timer(2).timeout
	box.bg.color = Color.BLACK
	player.set_mode(PlayerSoul.MODE.BLUE,"left",true)
	var dir_vec = Vector2.RIGHT
	var xpos = box.corner_left.x
	
	get_tree().create_timer(0.35).timeout.connect(
	sprinkle_bone.bind(Vector2(xpos-dir_vec.x*20,box.center.y),
			dir_vec,dist,cnt,dur,rnd_type))
	await get_tree().create_timer(0.75).timeout
	
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	dir_vec = Vector2.UP
	var ypos = box.corner_bottom.y
	
	
	get_tree().create_timer(0.35).timeout.connect(
	sprinkle_bone.bind(Vector2(box.center.x,ypos-dir_vec.y*20),
			dir_vec,dist,cnt,dur,rnd_type))
	await get_tree().create_timer(0.5).timeout
	
	bone_cross(Vector2(box.center.x-300,box.corner_bottom.y-60),-2,1,60,6,0,true)
	
	var c1 = bone_circle(box.center-Vector2(220,-40),35,0,3,2,1,3,0,true)
	create_tween().tween_property(c1,"bone_size",15,1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1).timeout
	
	bone_cross(Vector2(box.center.x+300,box.corner_bottom.y-60),-2,1,60,-6,0,true)
	var c2 = bone_circle(box.center+Vector2(220,40),35,0,3,-2,1,-3,0,true)
	create_tween().tween_property(c2,"bone_size",15,1).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(1).timeout
	
	var c3 = bone_circle(box.center,250,0,15,4,100,0,0,true)
	boomerang(c3,"radius",250,90,1.5)
	
	await get_tree().create_timer(1).timeout
	#box.bg.color = Color.PURPLE
	player.set_mode(PlayerSoul.MODE.BLUE,"right",true)
	dir_vec = Vector2.LEFT
	xpos = box.corner_right.x
	
	get_tree().create_timer(0.35).timeout.connect(
	sprinkle_bone.bind(Vector2(xpos-dir_vec.x*20,box.center.y),
			dir_vec,dist,cnt,dur,rnd_type))
			
	await get_tree().create_timer(1).timeout
	
	get_tree().create_timer(2).timeout.connect(func():box.bg.color = Color.GREEN_YELLOW)
	player.set_mode(PlayerSoul.MODE.BLUE,"up",true)
	dir_vec = Vector2.DOWN
	ypos = box.corner_right.y
	
	get_tree().create_timer(0.35).timeout.connect(
	sprinkle_bone.bind(Vector2(box.center.x,ypos-dir_vec.y*20),
			dir_vec,dist,cnt,dur,rnd_type))
	
	for i in 8:
		if i % 3 == 0:
			redressing_bones.call()
		
		var start = Vector2(randi_range(0,640),-80)
		var end = Vector2(randi_range(100,540),100)
		dust_gaster_blaster(start,end,angle_to_target(end,player.global_position),.35,0)
		await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(1).timeout
	box.bg.color = Color.BLACK
	attacks_manager.attack_end()

func bone_cross(_pos : Vector2,_ang_spd:float=2,_type:int = 0,_size:float=40,
		_xspd:float=0,_yspd:float=0,_hide:bool = true):
	var b1 = bone(_pos,_type,0,Vector2(_size,_size),_xspd,_yspd,_hide)
	var b2 = bone(_pos,_type,90,Vector2(_size,_size),_xspd,_yspd,_hide)
	b1.ang_spd = _ang_spd
	b2.ang_spd = _ang_spd

func tornado(_size:float = 35,_delay:float = 0.1,_spd=1.):
	var siner : float = 0.0
	var amp = 10
	var start_ec = 180
	var to_ec = 90
	tor2(_size,_delay,_spd)
	for i in 10:
		var b1 = bone(Vector2(box.center.x+start_ec,box.corner_right.y-10),-1,0,Vector2(0,(_size)+sin(siner)*amp),0,0,true)
		var b2 = bone(Vector2(box.center.x+start_ec,box.corner_bottom.y-10),-1,0,Vector2((_size)-sin(siner)*amp,0),0,0,true)
		
		if i % 2 == 0:
			b1.custom_color = Color.RED
			b2.custom_color = Color.RED
		else:
			b1.custom_color = Color.PURPLE
			b2.custom_color = Color.PURPLE
		
		boomerang(b1,"position:x",b1.position.x,box.center.x+to_ec,_spd,15)
		boomerang(b2,"position:x",b2.position.x,box.center.x+to_ec,_spd,15)
		siner += PI/5.0
		await get_tree().create_timer(_delay).timeout

func tor2(_size:float = 35,_delay:float = 0.3,_spd=1.5):
	var siner : float = 0.0
	var amp = 10
	var start_ec = 180
	var to_ec = 90
	for i in 10:
		var b1 = bone(Vector2(box.center.x-start_ec,box.corner_left.y-10),-1,0,Vector2(0,(_size)+sin(siner)*amp),0,0,true)
		var b2 = bone(Vector2(box.center.x-start_ec,box.corner_b_left.y-10),-1,0,Vector2((_size)-sin(siner)*amp,0),0,0,true)
		
		if i % 2 == 1:
			b1.custom_color = Color.RED
			b2.custom_color = Color.RED
		else:
			b1.custom_color = Color.PURPLE
			b2.custom_color = Color.PURPLE
		
		boomerang(b1,"position:x",b1.position.x,box.center.x-to_ec,_spd,15)
		boomerang(b2,"position:x",b2.position.x,box.center.x-to_ec,_spd,15)
		siner += PI/5.0
		
		await get_tree().create_timer(_delay).timeout

func attack_finished():
	pass

