extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(100,70)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

func main_attack():
	var ang = [0,180]
	for i in 20:
		gaster_crasher(player.global_position,ang[i%2]+randi_range(-10,10),1,0,12)
		await get_tree().create_timer(0.35).timeout
	for i in 20:
		var x_pos = randi_range(box.corner_left.x,box.corner_right.x)
		gaster_blaster(Vector2.ZERO,Vector2(x_pos,150),0,1)
		await get_tree().create_timer(0.35).timeout
	gaster_blaster(Vector2(640,-100),Vector2(590,320),90,1,0,12)
	var tween = create_tween()
	tween.tween_property(box,"yscale",10,.5).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.5).timeout
	for i in 10:
		if i%2==0:
			ortho_blaster(player.global_position,1)
		else:
			cross_blaster(player.global_position,1)
		await get_tree().create_timer(0.95).timeout
	await get_tree().create_timer(1.25).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass


func ortho_blaster(_pos:Vector2,_size:float):
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y-100),0,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y+100),180,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y),-90,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y),90,_size)

func cross_blaster(_pos:Vector2,_size:float):
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y-100),-45,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y+100),-45-90,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y-100),45,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y+100),90+45,_size)
