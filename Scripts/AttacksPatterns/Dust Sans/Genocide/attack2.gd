extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(200,80)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.BLUE,"up")
	var node = Node2D.new()
	node.position = box.center
	attacks_manager.mask.add_child(node)
	
	var igap = 10
	var loop_dur = 0.35/4.0
	var arr = []
	var arr2 = []
	for i in 20:
		var bpos = 230
		var b = bone(Vector2(bpos-igap*i,-60),0,0,Vector2(1,1),0,0,true,false)
		var b2 = bone(Vector2(-bpos+igap*i,50),0,0,Vector2(1,1),0,0,true,false)
		arr.append(b)
		arr2.append(b2)
		b.offs = false
		b2.offs = false
		node.add_child(b)
		node.add_child(b2)
		
		var dur = 0.3
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(b,"offset_down",70,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(b,"offset_top",70,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(b2,"offset_down",70,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(b2,"offset_top",70,dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		get_tree().create_timer(dur).timeout.connect(func(): Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg"))
		
		if i % 4 == 0:
			var spd = 10
			var f = fire(box.corner_right,-spd,0,true)
			f.rotation_degrees = 180
			f.scale = Vector2(1.25,1.25)
			f.position.y+=4
			fire(box.corner_b_left+Vector2(0,-4),spd,0,true).scale = Vector2(1.25,1.25)
			Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
		
		await get_tree().create_timer(loop_dur).timeout
	
	for i in node.get_child_count():
		var child = node.get_child(i)
		var tt = create_tween()
		tt.set_parallel()
		tt.tween_property(child,"offset_top",130,0.35).as_relative().set_trans(Tween.TRANS_SINE)
		tt.tween_property(child,"offset_down",130,0.35).as_relative().set_trans(Tween.TRANS_SINE)
	
	create_tween().tween_property(node,"rotation_degrees",90,0.5).set_trans(Tween.TRANS_SINE)
	create_tween().tween_property(box,"yscale",0,.25).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.25).timeout
	var grinder_bone = func(pos:Vector2,spd=0.5):
		var off = Vector2(0,200)
		var b1 = bone(pos-off,0,0,Vector2(1,1),0,0,true)
		var b2 = bone(pos+off,0,180,Vector2(1,1),0,0,true)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(b1,"offset_down",175,spd/2.0).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(b2,"offset_top",175,spd/2.0).set_trans(Tween.TRANS_BOUNCE)
		tween.chain()
		tween.tween_property(b1,"offset_down",1,spd/2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(b2,"offset_top",1,spd/2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
		Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
		get_tree().create_timer(spd/2.0).timeout.connect(func():Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg"))
	
	await get_tree().create_timer(0.5).timeout
	
	
	var bs = styled_bone_stab(box.corner_right-Vector2(-50,20),0,180,30,25,0,510)
	
	var plate = plateform(Vector2(box.center.x,100),1,180,60,Vector2(0,0),true)
	create_tween().tween_property(plate,"position:y",300,0.5).set_trans(Tween.TRANS_SINE).finished.connect(func():plate.xspeed = -1)
	
	var node_idx = -1
	var ups_bone = func(tmp,node):
				for x in range(arr.size()+tmp,0,-1):
					var child = arr[x]
					if child != null:
						var twe = create_tween()
						twe.set_parallel()
						twe.tween_property(child,"position:x",-2*igap,0.20).as_relative().set_trans(Tween.TRANS_SINE)
		
	for i in 10:
		var b1 = arr[node_idx]
		var b2 = arr[node_idx-1]
		node_idx -= 2
		
		if b1!=null && b2 != null:
			b1.type = 2
			if b2 != null : b2.type = 2
			var twe = create_tween()
			twe.set_parallel()
			twe.tween_property(b1,"yspeed",-6,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			if b2 != null : twe.tween_property(b2,"yspeed",-6,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			twe.finished.connect(func():
								await get_tree().create_timer(1).timeout
								if b2 != null : b2.queue_free()
								b1.queue_free())
		
		var tmp = node_idx
		ups_bone.call(tmp,node)
		
		
		#if i == 1:
			#grinder_bone.call(box.center-Vector2(25,0),1.5)
			#grinder_bone.call(box.center-Vector2(15,0),1.5)
		
		if i % 2 == 0:
			var fi1 = fire(Vector2(box.corner_right.x+150,randi_range(box.corner_right.y,box.corner_bottom.y)),0,0,false)
			var fi2 = fire(Vector2(box.corner_left.x-150,randi_range(box.corner_right.y,box.corner_bottom.y)),0,0,false)
			fi1.type = -1
			fi2.type = -1
			fi1.scale = Vector2(2,2)
			fi2.scale = Vector2(2,2)
			fi1.custom_color = Color.PURPLE
			fi2.custom_color = Color.PURPLE
			
			var explode = func(fi):
				if fi != null:
					Global.sound_player.play_sfx("res://Sounds/SFX/impact.ogg")
					
					var pos = fi.position
					var f = fire_circle(pos,-1,8,1,7,false)
					for ch in f.get_children():
						ch.free_on_contact = false
						ch.custom_color = Color.PURPLE
					
					main.camera.shake = 8
					fi.queue_free()
			
			var dur = 0.5
			var tween = create_tween()
			tween.set_parallel()
			tween.tween_property(fi1,"position:x",box.corner_right.x,dur)
			tween.tween_property(fi2,"position:x",box.corner_left.x,dur)
			tween.finished.connect(func():
				explode.call(fi1)
				explode.call(fi2))
		
		await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(0.5).timeout
	
	var down_bone = func():
		for i in range(arr2.size()-1,0,-1):
			var ch = arr2[i]
			if ch != null:
				var tw = create_tween()
				tw.tween_property(ch,"position:x",60,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			await get_tree().create_timer(0.05).timeout
	
	player.set_mode(PlayerSoul.MODE.BLUE,"down",true)
	for b in bs.bones.get_children():
		if b != null : create_tween().tween_property(b,"offset_top",40,1).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	for i in bs.bones.get_child_count():
		if bs != null:
			var chi = bs.bones.get_child(-1-i)
			if chi != null : 
				var spd = -6
				
				if i % 3 == 0:
					bone(box.corner_right+Vector2(20,-15),0,0,Vector2(0,100),spd,0,true)
				elif i%3 == 1 && i < 22:
					bone_stab(box.corner_b_left+Vector2(0,10),0,0,30,5,5,0)
				else:
					bone(Vector2(box.corner_bottom.x+50,320),1,0,Vector2(50,50),-6,0,true)
				if i > 22 : chi.type = 1
				
				create_tween().tween_property(chi,"offset_top",40,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				await get_tree().create_timer(0.25).timeout
	
	player.set_mode(PlayerSoul.MODE.RED)
	down_bone.call()
	#create_tween().tween_property(box,"xscale",400,2.4).set_trans(Tween.TRANS_SINE)
	for i in 8:
		var gap = 60
		var xpos = i*gap
		var sp = asgore_spear(Vector2(box.corner_left.x+xpos,600),-90,0,0,true)
		var sp2 = asgore_spear(Vector2(box.corner_right.x-xpos,600),-90,0,0,true)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(sp,"position:y",300,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(sp2,"position:y",300,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.chain()
		tween.tween_property(sp,"position:y",600,0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(sp2,"position:y",600,0.5).set_trans(Tween.TRANS_SINE)
		tween.step_finished.connect(func(x):
					if x== 0 :main.camera.shake = 10)
		tween.finished.connect(func():
					if sp != null : sp.queue_free()
					if sp2 != null : sp2.queue_free())
		var bo = bone(Vector2(box.corner_bottom.x+60,320),2,0,Vector2(50,50),-6,0,true)
		var bo2 = bone(Vector2(box.corner_b_left.x-60,320),2,0,Vector2(50,50),6,0,true)
		bo.ang_spd = 0.5
		bo2.ang_spd = -0.5
		Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
		
		await get_tree().create_timer(0.25).timeout
	
	player.shield_locked = true
	var a = []
	for i in 15:
		var gap = 35
		var xpos = i*gap
		var b = bone(box.corner_left+Vector2(xpos,0),-1,0,Vector2(1,1),0,0,true)
		create_tween().tween_property(b,"offset_down",100,0.5)
		Global.sound_player.play_sfx("res://Sounds/SFX/snd_spearrise.ogg")
		b.custom_color = Color.GREEN_YELLOW
		a.append(b)
		await get_tree().create_timer(0.1).timeout
		
	await get_tree().create_timer(0.5).timeout
	for i in a.size():
		create_tween().tween_property(a[i],"position:x",-30,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await get_tree().create_timer(2).timeout
	node.queue_free()
	attacks_manager.attack_end()

func opening(pos1:Vector2,pos2:Vector2,_spd:float=-2,ang:float=0,op_pos=20):
	var up = Vector2.UP*5
	var rnd = op_pos
	bone(pos1+up,0,ang,Vector2(rnd,35),_spd,0,true)
	bone(pos2+up,0,-ang,Vector2(0,85-rnd),_spd,0,true)

func styled_bone_stab(_pos:Vector2,_type:int,_angle:float,_count:int = 12,_height:float=30,_wait:float = 15,_hold:float=30,_delay:int=2,_gaps:float = 5,_alert:bool = true):
	var i = bone_stab(_pos,_type,_angle,_count,_height,_wait,_hold,_gaps,_alert,3)
	i.delay = _delay
	return i

func attack_finished():
	pass

