extends AttackPattern


# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,-10)

func pre_attack():
	player.global_position = box.center

func main_attack():
	var ang = randi_range(-180,180)
	var dir = [-1,1].pick_random()
	for i in 20:
		gaster_blaster(Vector2.ZERO,box.center,ang*dir)
		fire(Vector2(randi_range(200,500),-50),0,5,false)
		ang += 10
		await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(2).timeout
	attacks_manager.attack_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
