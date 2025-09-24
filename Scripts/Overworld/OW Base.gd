extends Node2D
class_name Overworld

@export var RoomName : String = "Test1"
@export var Encounter : Array[BattleData] = []
@export var Menu : OWMenu = null
@export var text_box : OWBox = null
@export var player : OWPlayer = null
@export var entry_node : Node = null
@export var exit_node : Node = null
@export var camera : BattleCamera = null

@export_group("Camera Limits")

@export var limit_up : int = -100000
@export var limit_down : int = 100000
@export var limit_left : int = -100000
@export var limit_right : int = 100000

var exit_array : Array[OWExit] = []
var entry_array : Array[OWEntry] = []

# We Initialize things
func _ready():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,0.5) # Some sort of intro you can modify it
	
	if Global.Game_Data["SavePos"].is_finite():
		player.global_position = Global.Game_Data["SavePos"]
	
	Menu.text = text_box.text
	Menu.player = player
	camera.limit_bottom = limit_down
	camera.limit_left = limit_left
	camera.limit_right = limit_right
	camera.limit_top = limit_up

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
		set_menu()

# This function initialize the Overworl Menu
func set_menu():
	Menu.visible = !Menu.visible
	# if the menu is not visible then we reset it
	if !Menu.visible:Menu._reset()
	#else we stop the player
	else : 
		player.idle()
		player.velocity = Vector2.ZERO

func set_entry():
	for i in entry_node.get_children():
		i.player = player
