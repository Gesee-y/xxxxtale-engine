extends AttackPattern

var a : Array[Bullet] = []
var b : Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(100,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

func main_attack():
	for i in 20:
		var twe = create_tween()
		twe.set_parallel()
		twe.set_loops(11)
		a.append(fire(Vector2(box.corner_right.x+40-i*35,box.corner_right.y+10),0,0,true,90))
		b.append(fire(Vector2(box.corner_b_left.x-40+i*35,box.corner_b_left.y-10),0,0,true,-90))
		if a[i] != null:
			twe.tween_property(a[i],"position:x",-40,.5).as_relative().set_trans(Tween.TRANS_SINE)
		if b[i]!=null:
			twe.tween_property(b[i],"position:x",40,.5).as_relative().set_trans(Tween.TRANS_SINE)
		twe.chain()
		if a[i] != null:
			twe.tween_property(a[i],"position:x",40,.5).as_relative().set_trans(Tween.TRANS_SINE)
		if b[i]!=null:
			twe.tween_property(b[i],"position:x",-40,.5).as_relative().set_trans(Tween.TRANS_SINE)
	
	for i in 10:
		ortho_blaster(player.global_position,1)
		await get_tree().create_timer(0.95).timeout
	await get_tree().create_timer(0.5).timeout
	for fi1 in a:
		if fi1 != null:
			fi1.type = 1
			fi1.yspeed = 6
	for fi2 in b:
		if fi2 != null:
			fi2.type = 2
			fi2.yspeed = -6
	await get_tree().create_timer(0.75).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

func ortho_blaster(_pos:Vector2,_size:float):
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y-100),0,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x,_pos.y+100),180,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x-100,_pos.y),-90,_size)
	gaster_blaster(Vector2.ZERO,Vector2(_pos.x+100,_pos.y),90,_size)
