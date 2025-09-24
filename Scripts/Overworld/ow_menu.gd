extends Node2D
class_name OWMenu

# exporting some value that should be passed by an external node(the parent node)
@export var text : Writer
@export var player : OWPlayer = null

# a reference to every node we will use for this
@onready var border_1 = $border1
@onready var border_2 = $border2
@onready var border_3 = $border3
@onready var Name = $border1/name
@onready var lv = $border1/lv
@onready var hp = $border1/hp
@onready var gold = $border1/gold
@onready var items = $border2/Items
@onready var stats = $border2/Stats
@onready var cell = $border2/Cell
@onready var soul = $soul
@onready var use = $Use
@onready var info = $Info
@onready var drop = $Drop

# some value for the navigation
var menu_no : int = -1
var selected : int = 1
var temp : int = 0
var showed : bool = false

func _ready():
	border_3.visible = false

func _process(_delta):
	use.visible = true if (border_3.visible and (menu_no == 0 or menu_no == -2)) else false
	info.visible = true if (border_3.visible and (menu_no == 0 or menu_no == -2)) else false
	drop.visible = true if (border_3.visible and (menu_no == 0 or menu_no == -2)) else false
	if visible:
		player.lock = true
		set_header()
		match menu_no:
			-2:
				var dir = int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"))
				if dir != 0: Global.sound_player.play_sfx("res://Sounds/SFX/menu_move.ogg")
				selected = posmod(selected+dir,3)
				set_soul_position3(selected)
				if Input.is_action_just_pressed("accept"):
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					menu_no = -3
					match selected:
						0:
							GameFunc.UseItem(Global.Items[temp],0,0,null,text,true)
						1:
							text.end_writer()
							text.set_dialogue(Global.Items[temp].info,true)
							text.next_string()
						2:
							text.end_writer()
							text.set_dialogue(Global.Items[temp].drop_text,true)
							text.next_string()
							Global.Items.remove_at(temp)
					_reset()
				if Input.is_action_just_pressed("cancel"):
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					menu_no = 0
					selected = temp
			-1:
				var dir = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
				if dir != 0: Global.sound_player.play_sfx("res://Sounds/SFX/menu_move.ogg")
				selected = wrapi(selected+dir,1,4)
				set_soul_position(selected)
				if Input.is_action_just_pressed("accept"):
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					menu_no = selected-1
					border_3.visible = true
					showed = false
					selected = 1
				if Input.is_action_just_pressed("cancel"):
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					_reset()
			0:
				if !showed:
					show_items()
					showed = true
				var dir = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
				if dir != 0: Global.sound_player.play_sfx("res://Sounds/SFX/menu_move.ogg")
				selected = wrapi(selected+dir,1,Global.Items.size()+1)
				set_soul_position2(selected)
				if Input.is_action_just_pressed("accept"):
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					menu_no = -2
					border_3.visible = true
					temp = selected-1
					selected = 0
				if Input.is_action_just_pressed("cancel"):
					reset_border3()
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					menu_no = -1
					selected = 0
			1:
				if !showed:
					showed = true
					var lab = RichTextLabel.new()
					lab.add_theme_font_size_override("normal_font_size",32)
					lab.add_theme_font_override("normal_font",load("res://Resources/Fonts/Determination Mono.ttf"))
					lab.size = Vector2(370,440)
					lab.position.x = 10
					lab.position.y = 20
					var armo = Global.players[0].armor
					var def = 0
					if armo.long_name == "Bandage":
						def = 0
					else:
						def = armo.defense
					var stri = ("\""+Global.players[0].Name+"\""+"\n\n"
					+"LV "+str(Global.players[0].LV)+"\n"
					+"HP " + str(Global.players[0].hp)+"/"+str(Global.players[0].max_hp)+"\n\n"
					+"AT:" +str(Global.players[0].attack)+"("+str(Global.players[0].weapon.damage)+")"+"     "+"EXP:" +str(Global.Game_Data["Exp"])+"\n"
					+"DF:" +str(Global.players[0].defense)+"("+str(def)+")"+"     "+"NEXT:"+str(0)+"\n\n"
					+"WEAPON:"+str(Global.players[0].weapon.long_name)+"\n"
					+"ARMOR:" +str(Global.players[0].armor.long_name)+"\n\n"
					+"GOLD:"+str(Global.Game_Data["Gold"])+ "     "+" KILLS:"+str(Global.Game_Data["Enemy_killed"]))
					lab.text = stri
					border_3.add_child(lab)
				if Input.is_action_just_pressed("cancel"):
					reset_border3()
					Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
					menu_no = -1
					selected = 1
			2:
				menu_no=-1
				selected = 2
				border_3.visible = false

func show_items():
	for i in Global.Items.size():
		var lab = RichTextLabel.new()
		lab.add_theme_font_size_override("normal_font_size",32)
		lab.add_theme_font_override("normal_font",load("res://Resources/Fonts/Determination Mono.ttf"))
		lab.text = Global.Items[i].long_name
		lab.size = Vector2(300,40)
		lab.position.x = 60
		lab.position.y = 20 + i*30
		border_3.add_child(lab)

func reset_border3():
	border_3.visible = false
	showed = false
	for i in border_3.get_children():
		if i.name != "BG" : i.queue_free()

func set_header():
	Name.text = Global.players[0].Name
	lv.text = "LV  " + str(Global.players[0].LV)
	hp.text = "HP  "+str(Global.players[0].hp) + "/" + str(Global.players[0].max_hp)
	gold.text = "G   " + str(Global.Game_Data["Gold"])

func set_soul_position3(_selected):
	var arr = [use,info,drop]
	soul.global_position.x = arr[_selected].global_position.x-20
	soul.global_position.y = arr[_selected].global_position.y+17

func set_soul_position2(_selected):
	soul.global_position.x = border_3.get_child(_selected).global_position.x-20
	soul.global_position.y = border_3.get_child(_selected).global_position.y+17

func set_soul_position(_selected):
	soul.global_position.x = border_2.get_child(_selected).global_position.x-15
	soul.global_position.y = border_2.get_child(_selected).global_position.y+17

func _reset():
	visible = false
	player.lock = false
	menu_no = -1
	selected = 0
	border_3.visible = false
	showed = false
	temp = 0
	reset_border3()
