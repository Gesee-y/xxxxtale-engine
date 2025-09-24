extends Node2D
class_name ButtonController

signal menu_selected(menu:int)

@export var player : PlayerSoul = null
var function = RegFunc.new()
var button_set : ButtonSet = load("res://Resources/ButtonSet/Default.tres")
var button_y : float = 450
var button_pos: Array[Vector2]= [
	Vector2(90,button_y),Vector2(244,button_y),
	Vector2(398,button_y),Vector2(552,button_y)
]

var move_buffer : int = 0
var selected : int = -1

func _ready():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,0.5)
	draw_UI_buttons()

func _process(_delta):
	if selected != -1 : navigate()
	else : if Global.current_phase != Global.phase.PLAYER : set_selected(10) # Unselect all button since no button idx would match this

func draw_UI_buttons():
	button_set.set_buttons()
	for i in 4:
		var sprite = AnimatedSprite2D.new()
		sprite.sprite_frames = button_set.buttons[i]
		sprite.position = button_pos[i]
		add_child(sprite)

func navigate():
	player.lock = true
	var dir = int(Input.is_action_just_pressed("right"))-int(Input.is_action_just_pressed("left"))
	if dir != 0: Global.sound_player.play_sfx("res://Sounds/SFX/menu_move.ogg")
	selected = posmod(selected+dir,4)
	player.position = button_pos[selected] + button_set.margin
	set_selected(selected)
	if Input.is_action_just_pressed("accept"):
		Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
		emit_signal("menu_selected",selected)

func set_selected(_idx):
	for i in get_child_count():
		if get_child(i) is AnimatedSprite2D:
			get_child(i).animation = "normal"
			if i == _idx : get_child(i).animation = "selected"
		
