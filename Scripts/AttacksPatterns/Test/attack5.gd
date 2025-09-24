extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(300,0)


func pre_attack():
	player.global_position = box.center

func main_attack():
	for i in 15:
		var x_pos = randi_range(box.corner_left.x,box.corner_right.x)
		var y_pos = player.global_position.y
		gaster_blaster(Vector2(0,680),Vector2(540,y_pos),90,.75,1,10)
		gaster_crasher(Vector2(x_pos,320),0,1,0,25)
		await get_tree().create_timer(0.75).timeout
	await get_tree().create_timer(0.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

