extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(200,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.global_position = box.center

func main_attack():
	for i in 12:
		var tween = create_tween()
		tween.set_parallel()
		gaster_blaster(Vector2.ZERO,player.global_position,randi_range(-180,180),.75)
		
		var ty = Vector2(2,2) if i != 11 else  Vector2(1,1)
		var fw1 = fire_wall(Vector2(box.corner_right.x+40,box.center.y),-10,0,0,ty.x,7,true)
		var fw2 = fire_wall(Vector2(box.corner_left.x-40,box.center.y),10,0,0,ty.y,7,true)
		tween.tween_property(fw1,"rotation_degrees",-10000,3)
		tween.tween_property(fw2,"rotation_degrees",10000,3)
		await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(1).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

func fire_wall(pos,xspd,yspd,angle,_type,num,_hide:bool=true,default_parent = true):
	var nod = Bullet.new()
	if default_parent:
		mask.add_child(nod)
	nod.rotation_degrees = angle
	nod.xspeed = xspd
	nod.yspeed = yspd
	nod.global_position = pos
	var mid = num/2.0
	for i in num:
		var s = fire(Vector2(0,(-15*mid)+i*15),0,0,_hide,0,_type,false)
		nod.add_child(s)
	return nod
