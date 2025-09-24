extends Node2D

var soul_pos : Vector2
@onready var soul = $soul
var fader : ColorRect = null
var timer : int = 0
var button_pos: Vector2= Vector2(90,450)

# Called when the node enters the scene tree for the first time.
func _ready():
	soul_pos = GameFunc.current_room[1] - GameFunc.camera_pos
	soul.global_position = soul_pos
	soul.modulate = Color.RED
	fader = Global.display.fader
	fader.modulate.a = 1
	fader.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if timer % 5 == 0 and timer != 0 and timer <= 20:
		fader.visible = !fader.visible
		Global.sound_player.play_sfx("res://Sounds/SFX/flash.ogg")
	if timer == 20:
		Global.sound_player.play_sfx("res://Sounds/SFX/start.wav")
		fader.visible = true
		fader.modulate.a = 0
		var tween = create_tween()
		tween.tween_property(soul,"position",button_pos,1).set_trans(Tween.TRANS_SINE)
		Global.display.fade(Color.BLACK,G_Display.TYPE.IN,1)
		var go_to_battle = func():
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://Scenes/battle/BattleRoom.tscn")
		tween.finished.connect(func():go_to_battle.call())
			
	timer += 1
