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
	for i in 15:
		gaster_crasher(player.global_position,ang[i%2]+randi_range(-10,10),1,0,12)
		await get_tree().create_timer(0.5).timeout
	attack_end()

func attack_finished():
	pass

