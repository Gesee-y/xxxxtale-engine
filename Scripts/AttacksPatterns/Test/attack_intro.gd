extends AttackPattern

func _ready():
	box_pre = Vector2(400,0)

func main_attack():
	for i in 4:
		var start = Vector2(0,0)
		var end = Vector2(randi_range(100,500),randi_range(40,440))
		gaster_blaster(start,end,randi_range(-180,180))
		await get_tree().create_timer(0.5).timeout
	ortho_blaster(box.center,1)
	await get_tree().create_timer(.75).timeout
	cross_blaster(box.center,1)
	await get_tree().create_timer(.75).timeout
	gaster_blaster(Vector2.ZERO,Vector2(box.center.x-100,box.center.y),-90,1.25,0,10,10)
	gaster_blaster(Vector2.ZERO,Vector2(box.center.x+100,box.center.y),90,1.25,0,10,10)
	await get_tree().create_timer(.5).timeout
	var en = main.enemy_manager
	en.visible = true
	en.modulate.a = 0
	var tween = create_tween()
	attacks_manager.pattern = ["res://Scripts/AttacksPatterns/Test/attack0.gd",
			"res://Scripts/AttacksPatterns/Test/attack1.gd",
			"res://Scripts/AttacksPatterns/Test/attack3.gd",
			"res://Scripts/AttacksPatterns/Test/attack2.gd",
			"res://Scripts/AttacksPatterns/Test/attack8.gd",
			"res://Scripts/AttacksPatterns/Test/attack5.gd",
			"res://Scripts/AttacksPatterns/Test/attack6.gd",
			"res://Scripts/AttacksPatterns/Test/attack7.gd",
			"res://Scripts/AttacksPatterns/Test/attack4.gd"]
	tween.tween_property(en,"modulate:a",1,1)
	await get_tree().create_timer(2).timeout
	attacks_manager.attack_end()
	main.event_manager.turn = 0
	
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
