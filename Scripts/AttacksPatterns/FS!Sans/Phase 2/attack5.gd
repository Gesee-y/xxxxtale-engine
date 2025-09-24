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
	var cir2 = bone_circle(box.center,150,2,4,-3,75,0,0,true)
	var cir1 = bone_circle(box.center,150,0,5,3,90,0,0,true)
	var twe = create_tween()
	twe.set_parallel()
	twe.tween_property(box,"xpos",-130,3).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir1,"position:x",-130,3).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir2,"position:x",-130,3).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir1,"radius",80,1).set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir2,"radius",50,1).set_trans(Tween.TRANS_SINE)
	twe.chain()
	twe.tween_property(cir1,"radius",110,1).set_trans(Tween.TRANS_SINE)
	twe.tween_property(cir1,"position:y",-230,1).as_relative().set_trans(Tween.TRANS_SINE)
	twe.connect("finished",Callable(self,"set_box"))
	await get_tree().create_timer(3).timeout
	cir1.type = 1
	await get_tree().create_timer(0.5).timeout
	
	var tt = create_tween()
	var poly1 = bone_polygon(Vector2(100,100),10,1,5,2,0,0,true)
	var poly2 = bone_polygon(Vector2(270,100),10,1,5,2,0,0,true)
	tt.set_parallel()
	tt.tween_property(poly1,"position:y",300,1).set_trans(Tween.TRANS_SINE)
	tt.tween_property(poly2,"position:y",300,1).set_trans(Tween.TRANS_SINE)
	
	player.set_mode(PlayerSoul.MODE.BLUE)
	for i in 20:
		bone_polygon(box.corner_bottom,10,0,5,2,-3,0,true)
		if i % 2 == 0:
			
			fs_gaster_blaster(player.global_position-Vector2(0,500),Vector2(player.global_position.x,150),0,1,0,0,0)
		await get_tree().create_timer(0.75).timeout
	await get_tree().create_timer(0.75).timeout
	attacks_manager.attack_end()

func set_box():
	var twe = create_tween()
	twe.tween_property(box,"xscale",200,1).set_trans(Tween.TRANS_SINE)
	await twe.finished
	bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,20,10,1000).up_down()
	bone_stab(box.corner_left-Vector2(10,0),0,90,12,20,10,1000).up_down()

func attack_finished():
	pass

func bone_cross(_pos : Vector2,_ang_spd:float=2,_type:int = 0,_size:float=40,
		_xspd:float=0,_yspd:float=0,_hide:bool = true):
	var b1 = bone(_pos,_type,0,Vector2(_size,_size),_xspd,_yspd,_hide)
	var b2 = bone(_pos,_type,90,Vector2(_size,_size),_xspd,_yspd,_hide)
	b1.ang_spd = _ang_spd
	b2.ang_spd = _ang_spd
