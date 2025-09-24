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
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(box,"xpos",-100,.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(box,"angle",180,.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.chain()
	tween.tween_property(box,"ypos",-50,.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(box,"xscale",450,.5).set_trans(Tween.TRANS_SINE)
	await tween.finished
	box.can_push = "right"
	for i in 10:
		var start = Vector2(0,550)
		var end = Vector2(90+i*40,400)
		gaster_blaster(start,end,180,.75,0,780+i*2,0)
	for i in 60:
		fire(Vector2(0,randi_range(220,340)),3,0,true)
		await get_tree().create_timer(.25).timeout
	await get_tree().create_timer(.5).timeout
	attacks_manager.attack_end()

func attack_finished():
	pass

