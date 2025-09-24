extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,-10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

func main_attack():
	var y_pos = [280,360]
	var x_pos = [280,350]
	var s = 0
	for i in 40:
		fire(Vector2(box.corner_right.x+40,box.corner_right.y),-4,0,true,180)
		fire(Vector2(box.corner_b_left.x-40,box.corner_b_left.y),4,0,true,0)
		fire(Vector2(box.corner_b_left.x-40,box.center.y),6,0,true,0)
		if i % 4 == 0 and i < 20:
			gaster_blaster(Vector2(640,-100),Vector2(540,y_pos[s%2]),90,.65)
			s+=1
		if i == 20:
			gaster_blaster(Vector2(450,500),Vector2(320,450),180,.65)
		if i>22:
			fire(Vector2(box.center.x,450),0,-4,true,0)
			if i % 4 == 0:
				gaster_blaster(Vector2(640,-100),Vector2(540,350),90,.65,0,10)
			if i % 4 == 1:
				gaster_blaster(Vector2.ZERO,Vector2(360,150),0,.65,0,10)
			if i % 4 == 2:
				gaster_blaster(Vector2.ZERO,Vector2(130,280),-90,.65,0,10)
			if i % 4 == 3:
				gaster_blaster(Vector2.ZERO,Vector2(280,450),180,.65,0,10)
		await get_tree().create_timer(.5).timeout
	await get_tree().create_timer(.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

