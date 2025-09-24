extends Node2D

var quitting = false
var start_scroll = false
var finish = false
@onready var game_name = $"Game Name"
@onready var engine = $Engine
@onready var camera = $Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade_time := 0.3
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,fade_time)
	await get_tree().create_timer(fade_time).timeout
	await Intro()
	
	await get_tree().create_timer(2).timeout
	var scroll_distance = 1500
	create_tween().tween_property(camera,"offset:y",scroll_distance,30).finished.connect(func():finish = true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("accept") and !quitting and finish:
		quitting = true
		Global.display.fade(Color.BLACK)
		await get_tree().create_timer(2).timeout
		get_tree().quit()

func Intro():
	Global.sound_player.play_sfx("res://Sounds/SFX/undertale.ogg")
	game_name.visible = true
	if Flags.HardMode :
		await get_tree().create_timer(1).timeout
		$Hard.visible = true
		Global.sound_player.play_sfx("res://Sounds/SFX/mus_mode.ogg")
	await get_tree().create_timer(2).timeout
	
	Global.sound_player.play_sfx("res://Sounds/SFX/undertale.ogg")
	engine.visible = true
