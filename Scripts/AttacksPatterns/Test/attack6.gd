extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

func main_attack():
	for i in 25:
		var x_pos = randi_range(box.corner_left.x,box.corner_right.x)
		var start = Vector2(randi_range(0,640),-80)
		var end = Vector2(randi_range(100,540),100)
		if i %2==0:
			var fi = fire(Vector2(x_pos,450),0,0,true)
			boomerang(fi,"position:y",450,randi_range(260,320),2)
			var tween = create_tween()
			tween.tween_property(fi,"rotation_degrees",randi_range(180,720),3).set_trans(Tween.TRANS_SINE)
		gaster_blaster(start,end,angle_to_target(end,player.global_position),.6,2)
		await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

