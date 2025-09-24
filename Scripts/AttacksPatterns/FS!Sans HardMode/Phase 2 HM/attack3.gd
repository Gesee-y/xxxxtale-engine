extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(420,-10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	box.set_form("circle")
	player.position = box.center - Vector2(0,10)

func main_attack():
	var spd = 2
	var _size = 30
	var twe = create_tween()
	var cir = bone_circle(box.center,120,0,12,2,55,0,0,true)
	
	var blue_bone = bone(box.center,1,0,Vector2(_size,_size),0,0,true)
	var orange_bone = bone(box.center,2,0,Vector2(_size,_size),0,0,true)
	var bones = bone_circle(box.center+Vector2(-3,0),150,0,4,0,60,0,0,true)
	blue_bone.ang_spd = spd
	orange_bone.ang_spd = -spd
	create_tween().tween_property(bones,"radius",70,1)
	var plu = -20
	for i in 15:
		if i % 2 == 0 and i != 0:
			boomerang(bones,"radius",100,70,1.5)
		if i % 3 == 0:
			var _pos = Vector2(randi_range(100,500),randi_range(150,400))
			var start_pos = Vector2([randi_range(-100,-20),randi_range(660,740)].pick_random(),
					[randi_range(-100,-20),randi_range(500,600)].pick_random())
			var _ang = angle_to_target(_pos,player.global_position)
			
			fs_gaster_blaster(start_pos,_pos,_ang,0.5,0)
		
		var tween = create_tween()
		tween.set_parallel()
		
		plu = -plu
		var t = 100 if cir.radius == 120 else 120
		if i != 14 : tween.tween_property(box,"radius",plu,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(cir,"radius",t,0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(bones,"angle",40,0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tween.finished
		await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

