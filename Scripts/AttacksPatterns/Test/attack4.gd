extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

#gaster_crasher(_end:Vector2,_angle:float,_size:float=1,_type:int=0,
#		_wait:float=5,_spd:float = 2)

func main_attack():
	gaster_crasher(Vector2(320,box.corner_right.y+20),90)
	gaster_crasher(Vector2(320,box.corner_bottom.y-20),90)
	await get_tree().create_timer(0.5).timeout
	gaster_crasher(box.center,-90)
	await get_tree().create_timer(0.5).timeout
	for i in 10:
		var start = Vector2(0+i*75,-100)
		var end = Vector2(90+i*75,400)
		gaster_blaster(start,end,180,.75,0,5,0)
	await get_tree().create_timer(1.25).timeout
	var _targ = [Vector2(100,100),Vector2(540,100)]
	for i in 2:
		var ang = angle_to_target(_targ[i],player.global_position)
		gaster_crasher(_targ[i],ang)
		gaster_crasher(_targ[i],ang-30)
		gaster_crasher(_targ[i],ang+30)
		await get_tree().create_timer(0.75).timeout
	await get_tree().create_timer(0.25).timeout
	for i in 3:
		var start = Vector2(0,-100)
		var end = Vector2(20+i*120,100)
		var start2 = Vector2(0,100)
		var end2 = Vector2(640-i*120,100)
		gaster_blaster(start,end,-45,.75,0,5,0)
		gaster_blaster(start2,end2,45,.75,0,5,0)
	await get_tree().create_timer(0.75).timeout
	for i in 10:
		var start = Vector2(0,320)
		var end = Vector2(320,100)
		gaster_blaster(start,end,i*36,.75,0,5,0)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.75).timeout
	for i in 5:
		var start = Vector2(0,0)
		var end = Vector2(randi_range(100,500),randi_range(40,440))
		gaster_blaster(start,end,randi_range(-180,180))
		await get_tree().create_timer(0.5).timeout
	attacks_manager.random_attack = true
	attacks_manager.pattern = ["res://Scripts/AttacksPatterns/Test/attack1H.gd",
	"res://Scripts/AttacksPatterns/Test/attack6.gd",
	"res://Scripts/AttacksPatterns/Test/attack9H.gd"]
	attacks_manager.attack_end()

func attack_finished():
	pass

