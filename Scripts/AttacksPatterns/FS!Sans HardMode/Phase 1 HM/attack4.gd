extends AttackPattern

var stab 
var stab2

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,-10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if stab != null:
		var count = stab2.bones.get_child_count()
		for i in count:
			stab2.bones.get_child(i).offset_top = 30-stab.bones.get_child(-1-i).offset_top

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.BLUE,"down")
	stab = bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,20,10,800)
	stab2 = bone_stab(box.corner_left-Vector2(10,0),0,90,12,20,10,800)
	stab.sine_fx()
	var cou : int = 0
	while stab != null:
		if cou == 12:
			player.set_mode(PlayerSoul.MODE.RED)
		if cou < 12:
			bone(box.corner_bottom-Vector2(0,80),0,180,Vector2(65,0),-3,0,true)
			bone(box.corner_bottom-Vector2(0,20),0,180,Vector2(15,0),-3,0,true)
			
			bone(box.corner_bottom-Vector2(0,30),2,180,Vector2(90,0),-6,0,true)
			await get_tree().create_timer(0.55).timeout
		else :
			var _spd = -2
			if cou % 3 == 0:
				randomize()
				var up = Vector2.UP*5
				var rnd = randf_range(30,50)
				var b1= bone(box.corner_bottom-Vector2(0,0)+up,0,0,Vector2(rnd,35),_spd,0,true)
				var b2 = bone(Vector2(box.corner_right)-Vector2(0,0)+up,
					0,0,Vector2(0,85-rnd),_spd,0,true)
				var off = 20
				var dur = 0.5
				var twe = create_tween()
				twe.set_parallel()
				twe.set_loops(5)
				twe.tween_property(b1,"offset_top",off,dur).as_relative().set_trans(Tween.TRANS_SINE)
				twe.tween_property(b2,"offset_down",-off,dur).as_relative().set_trans(Tween.TRANS_SINE)
				twe.chain()
				twe.tween_property(b1,"offset_top",-off,dur).as_relative().set_trans(Tween.TRANS_SINE)
				twe.tween_property(b2,"offset_down",off,dur).as_relative().set_trans(Tween.TRANS_SINE)
				
			if cou % 3 == 1:
				bone(box.corner_bottom-Vector2(0,30),1,180,Vector2(90,0),_spd,0,true)
			if cou % 3 == 2:
				bone(box.corner_bottom-Vector2(0,30),2,180,Vector2(90,0),_spd,0,true)
			await get_tree().create_timer(0.35).timeout
		
		cou += 1
	
	await get_tree().create_timer(0.2).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

