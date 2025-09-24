extends AttackPattern

var stab 
var stab2

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(300,-30)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if stab != null:
		var count = stab2.bones.get_child_count()
		for i in count:
			stab2.bones.get_child(i).offset_top = 20-stab.bones.get_child(-1-i).offset_top

func pre_attack():
	pass

func main_attack():
	player.set_mode(PlayerSoul.MODE.BLUE,"down")
	stab = bone_stab(box.corner_right+Vector2(5,-5),0,180+10,30,25,30,5000)
	stab2 = bone_stab(box.corner_b_left+Vector2(-5,5),0,10,30,25,30,5000)
	var stab3 = bone_stab(box.corner_left-Vector2(10,0),0,90,12,20,30,5000)
	stab.sine_fx(20,0.5)
	stab3.sine_fx(20,0.2)
	await get_tree().create_timer(0.4).timeout
	for i in 50:
		var pl = plateform(Vector2(box.corner_right.x+40,box.corner_bottom.y-5)
				,0,0,40,Vector2(-3,-1),true)
		pl.set_to_center = true
		var twe = create_tween()
		twe.set_loops(30)
		twe.tween_property(pl,"rotation_degrees",20,0.3).set_trans(Tween.TRANS_SINE)
		twe.tween_property(pl,"rotation_degrees",-20,0.3).set_trans(Tween.TRANS_SINE)
		
		var b = bone(Vector2(randi_range(100,200),-100),randi_range(0,2),0,Vector2(0,30),0,0,false)
		var twe2 = create_tween()
		twe2.set_parallel()
		twe2.tween_property(b,"position",Vector2(box.corner_right.x+50,
				randi_range(box.corner_right.y+25,box.corner_bottom.y-25)),0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		twe2.tween_property(b,"rotation_degrees",90,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		twe2.chain()
		twe2.tween_property(b,"xspeed",-9,1).set_trans(Tween.TRANS_SINE)
		
		await get_tree().create_timer(0.25).timeout
	
	await get_tree().create_timer(0.5).timeout
	player.set_mode(PlayerSoul.MODE.BLUE,"right",true)
	bone_stab(box.corner_bottom+Vector2(10,0),0,-90,12,30,10,200)
	await get_tree().create_timer(0.75).timeout
	player.set_mode(PlayerSoul.MODE.RED)
	var b1 = bone(box.corner_right+Vector2(50,0),0,0,Vector2(0,60),0,0,true)
	var b2 = bone(box.corner_b_left-Vector2(50,0),0,0,Vector2(60+8,0),0,0,true)
	var twe = create_tween()
	twe.set_parallel()
	twe.tween_property(b1,"position:x",box.center.x-50,0.75).set_trans(Tween.TRANS_SINE)
	twe.tween_property(b2,"position:x",box.center.x+50,0.75).set_trans(Tween.TRANS_SINE)
	twe.chain()
	twe.tween_property(b1,"position:x",300,1.5).as_relative().set_trans(Tween.TRANS_SINE)
	twe.tween_property(b2,"position:x",-300,1.5).as_relative().set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(2.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

