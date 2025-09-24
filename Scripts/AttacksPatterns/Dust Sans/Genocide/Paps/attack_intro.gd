extends AttackPattern

# Called when the node enters the scene tree for the first time.
func _ready():
	box_pre = Vector2(400,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	player.set_mode(PlayerSoul.MODE.RED)
	Global.sound_player.pause_music("res://Sounds/BGM/dust_theme.ogg")

func main_attack():
	var sans = main.enemy_manager.enemies[0]
	var dialogue = ["{papyrus:none}Let's go human."]
	var pap_typer = load("res://Resources/Typers/Papyrus.tres")
	
	player.lock = true
	Global.display.click(0.5)
	await get_tree().create_timer(0.25).timeout
	sans.sprite.visible = false
	sans.paps_sprite.visible = true
	sans.writer.get_parent().typer = pap_typer
	
	await get_tree().create_timer(0.25).timeout
	sans.writer.set_dialogue(dialogue)
	sans.writer.next_string()
	
	await sans.writer.dialogue_finished
	
	Global.sound_player.play_bgm("res://Sounds/BGM/mus_papyrus_preboss.ogg")
	
	bone(box.center+Vector2(200,0),1,0,Vector2(40,40),8,0,true)
	await get_tree().create_timer(0.25).timeout
	player.lock = false
	bone(box.center+Vector2(200,0),1,0,Vector2(50,50),-5,0,true)
	await get_tree().create_timer(0.5).timeout
	
	player.set_mode(PlayerSoul.MODE.BLUE,"down",false)
	
	
	#sans.phantom_paps.visible = false

func attack_finished():
	pass

