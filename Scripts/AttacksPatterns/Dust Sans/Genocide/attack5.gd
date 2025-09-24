extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(430,30)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.RED)
	player.shield_locked = true
	var offs = 15
	
	var bc1 = bone_cross(box.corner_right+Vector2(-offs,-20),2,0,20,0,0,true)
	var bc2 = bone_cross(box.corner_b_left+Vector2(offs,20),-2,0,20,0,0,true)
	
	for i in bc1.size():
		var b1 = bc1[i]
		var b2 = bc2[i]
		
		var tween = create_tween()
		tween.set_parallel()
		
		tween.tween_property(b1,"position:y",box.corner_bottom.y-10,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(b2,"position:y",box.corner_left.y+10,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.chain()
		tween.tween_property(b1,"position:y",box.center.y-20,0.75).set_trans(Tween.TRANS_SINE)
		tween.tween_property(b2,"position:y",box.center.y+20,0.75).set_trans(Tween.TRANS_SINE)
		tween.chain()
		tween.tween_property(b1,"position:y",box.corner_bottom.y+20,0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(b2,"position:y",box.corner_left.y-20,0.5).set_trans(Tween.TRANS_SINE)
		
		tween.finished.connect(b1.queue_free)
		tween.finished.connect(b2.queue_free)
	
	var customized_sep_bones = func(pos:Vector2,set_player:bool = true):
		var circ = bone_circle(pos,200,0,2,0,50,0,0,true)
		
		var tween = create_tween()
		tween.set_parallel()
		
		tween.tween_property(circ,"radius",60,0.6).set_trans(Tween.TRANS_CIRC)
		tween.chain()
		tween.tween_property(box,"angle",90,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(circ,"angle",90,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
		if set_player : get_tree().create_timer(0.6).timeout.connect(func() : player.set_mode(PlayerSoul.MODE.BLUE,"down",false))
	
	for i in 9:
		var _spd = -7
		if i % 2 == 0 : bone(box.center+Vector2(0,150),0,0,Vector2(3,3),0,_spd,true)
		else:
			bone(box.center+Vector2(-20,150),0,0,Vector2(3,3),0,_spd,true)
			bone(box.center+Vector2(20,150),0,0,Vector2(3,3),0,_spd,true)
		
		await get_tree().create_timer(0.2).timeout
	
	customized_sep_bones.call(box.center)
	
	await get_tree().create_timer(0.6).timeout
	
	for i in 6:
		var rnd = randi_range(1,2)
		if rnd == 1:
			bone_stab(box.corner_right-Vector2(10,0),0,90,12,20,15,3)
		else:
			bone_stab(box.corner_b_left+Vector2(10,0),0,-90,12,20,15,3)
		await get_tree().create_timer(0.8).timeout
	
	create_tween().tween_property(box,"yscale",-160,0.5).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.5).timeout
	var _size = 70
	for i in 11:
		var h = _size - abs(-30+(i*6))
		var xpos = 540+i*10
		var bo = bone(Vector2(xpos,400),0,0,Vector2(h,1),-8,0,true)
		
	await get_tree().create_timer(1).timeout
	for i in 11:
		var h = _size - abs(-30+(i*6))
		var xpos = 140-i*10
		var bo = bone(Vector2(xpos,400),0,0,Vector2(h,1),8,0,true)
	await get_tree().create_timer(1).timeout
	for i in 11:
		var h = _size - abs(-30+(i*6))
		var xpos = 540+i*10
		var bo = bone(Vector2(xpos,400),0,0,Vector2(h,1),-8,0,true)
	for i in 11:
		var h = _size - abs(-30+(i*6))
		var xpos = 140-i*10
		var bo = bone(Vector2(xpos,400),0,0,Vector2(h,1),8,0,true)
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
