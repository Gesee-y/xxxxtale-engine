extends Node

#--------- Signal for gameplay ---------#

signal enemy_die
signal game_over

#---------- Player Data ------------#

var ENTRY_POINT : int = -1
var party_num : int = 1
var players : Array = [load("res://Resources/Characters/Them.tres")]
var player_name : String = "Chara"
var player_hp : int = 20
var player_max_hp : int = 20
var player_kr_hp : int = 20
var kr : bool = false
var location : String = ""
var player_speed : float = 3
var serious : bool = false
var death_pos : Vector2 = Vector2(320,240)
var min_hp : int = 1
var debug = false
var player_immortal : bool = false
var damage_multiplier : float = 1

enum phase{
	PLAYER,
	PLAYER_EVENTS,
	ENEMY_TARGET,
	ENEMY_EVENT,
	ENEMY_ATTACK,
	END,
	X,
	NULL
}

var current_phase : phase = phase.PLAYER
var current_fight : BattleData = load("res://Resources/Battle/Dust Sans Fight.tres")

#---------- Game Properties --------------#

var enemies_target : Array[Resource] = []
var boundaries : Dictionary = {
	"up":0,
	"down":0,
	"left":0,
	"right":0
}
var Items : Array = [
	"ButtsPie",
	"Bisicle",
	"S.Apron",
	"L.Hero",
	"Fab.DJ",
	"Ketchup",
	"Gold.Tea",
	"Ban.Sp",
]

var buttons : ButtonSet = load("res://Resources/ButtonSet/Default.tres")

#--------- Statistics and Parameters ------------#

var Game_Data : Dictionary = {
	"Name" : "Chara",
	"Location" : "",
	"Time" : 0,
	"Exp" : 0,
	"LV" : 1,
	"Attack" : 1,
	"Defense": 2,
	"Gold" : 0,
	"Enemy_killed" : 0,
	"Number_of_gameover" : 0,
	"SavePos" : Vector2(INF,INF)
}

# the game options

var Parameters : Dictionary = {
	"Volume Main" : 0,
	"Volume SFX" : 0,
	"FullScreen" : false,
	"Screen Resolution" : Vector2(640,480),
	"hdpi" : false,
	"VSync" : false
}

# The game inputs

var Keys_Config : Dictionary = {
	"up" : KEY_UP,
	"down" : KEY_DOWN,
	"left" : KEY_LEFT,
	"right" : KEY_RIGHT,
	"accept" : KEY_Z,
	"cancel" : KEY_X,
	"menu" : KEY_C
}

var accept_buffer : float = 0

#---------- Display and audio manager -----------#

var display = G_Display.new()
var sound_player = AudioManager.new()

#----------- Save and Load System----------------#

var save_file : String = "user://save.save"
var res_file : String = "user://res.save"

func save_data() -> void:
	var file : FileAccess = FileAccess.open(save_file,FileAccess.WRITE)
	file.store_var(Game_Data)
	file.store_var(Parameters)
	file.store_var(Keys_Config)
	file.store_var(players)
	file.store_var(Items)
	file.close()

func load_data() -> void:
	if FileAccess.file_exists(save_file):
		var file = FileAccess.open(save_file,FileAccess.READ)
		Game_Data = file.get_var()
		Parameters = file.get_var()
		Keys_Config = file.get_var()
		var _players = file.get_var()
		#for i in players.size():
			#players[i] = instance_from_id(players[i].get_instance_id())
		Items = file.get_var()
		file.close()
	else:
		default_game_value()
		default_parameters()
		default_inputs()
		save_data()

func default_game_value() -> void:
	Game_Data["Name"] = "Chara"
	Game_Data["Location"] = ""
	Game_Data["Time"] = 0
	Game_Data["SavePos"] = Vector2(INF,INF)
	Game_Data["Exp"] = 0
	Game_Data["LV"] = 1
	Game_Data["Gold"]=0
	Game_Data["Attack"] = 1
	Game_Data["Defense"] = 2
	Game_Data["Enemy_killed"] = 0
	Game_Data["Number_of_gameover"] = 0

func default_parameters() -> void:
	Parameters = {
	"Volume Main" : 0,
	"Volume SFX" : 0,
	"FullScreen" : false,
	"Screen Resolution" : Vector2(640,480),
	"hdpi" : false,
	"VSync" : false
}

func default_inputs() -> void:
	Keys_Config = {
	"up" : KEY_UP,
	"down" : KEY_DOWN,
	"left" : KEY_LEFT,
	"right" : KEY_RIGHT,
	"accept" : KEY_Z,
	"cancel" : KEY_X,
	"menu" : KEY_C
}

#----------- Parameters -------------#

func set_graphics() -> void:
	if Parameters["FullScreen"] == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	ProjectSettings.set_setting("display/window/size/viewport_width",Parameters["Screen Resolution"].x)
	ProjectSettings.set_setting("display/window/size/viewport_height",Parameters["Screen Resolution"].y)
	
	if Parameters["hdpi"] == true: get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	else:get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	
	if Parameters["VSync"] == true: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func set_sound_volume() -> void:
	var main = AudioServer.get_bus_index("Main")
	var sfx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(main,Parameters["Volume Main"])
	AudioServer.set_bus_volume_db(sfx,Parameters["Volume SFX"])

func rebind_input() -> void:
	for key in Keys_Config.keys():
		var new_event = InputEventKey.new()
		new_event.keycode = Keys_Config[key]
		InputMap.action_erase_events(key)
		InputMap.action_add_event(key,new_event)

func set_parameters(_key : String, _value:Variant) -> void:
	Parameters[_key] = _value

func set_input(_key : String, _value:Variant) -> void:
	Keys_Config[_key] = _value

#---------- Script ----------#

func _ready() -> void:
	add_child(display)
	add_child(sound_player)
	enemy_die.connect(_on_enemy_die)
	game_over.connect(_on_game_over)
	load_data()
	for player in players:
		player.armor = GameFunc.initialize_armor(player.armor_name)
		player.weapon = GameFunc.initialize_weapon(player.weapon_name)
	initialize_items()

func initialize_items():
	for i in Items.size():
		Items[i] = GameFunc.initialize_item(Items[i])

func _process(delta):
	clamp_player_hp()
	if Input.is_action_just_pressed("debug"):
		debug = !debug
	
	if debug or player_immortal : min_hp = 1
	else : min_hp = 0
	
	if Input.is_action_just_pressed("fullscreen") and accept_buffer <= 0:
		Parameters["FullScreen"] = !Parameters["FullScreen"]
		set_graphics()
		accept_buffer= .25
	if accept_buffer > 0:
		accept_buffer-=delta
	
	Game_Data["Time"] += delta

func clamp_player_hp():
	for i in players:
		i.hp = clampi(i.hp,min_hp,i.max_hp)
		i.kr_hp = clampi(i.kr_hp,i.hp,i.max_hp)

func _on_level_up(_amount) -> void:
	Game_Data["LV"] += _amount

func _on_enemy_die() -> void:
	Game_Data["Enemy_killed"] += 1

func _on_game_over() -> void:
	Game_Data["Number_of_gameover"] += 1

# ---------- End ---------- #
