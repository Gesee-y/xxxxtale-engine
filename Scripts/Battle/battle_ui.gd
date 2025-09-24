extends Node2D
class_name BattleUI

var main : BattleManager

var ui_font : FontFile = preload("res://Resources/Fonts/Mars_Needs_Cunnilingus.ttf")
var ui_hp_font : FontFile = preload("res://Resources/Fonts/dotumche.ttf")

var name_label : RichTextLabel = RichTextLabel.new()
var hp_label : RichTextLabel = RichTextLabel.new()
var label_hp : RichTextLabel = RichTextLabel.new()
var label_kr : RichTextLabel = RichTextLabel.new()

var shield_bar : ProgressBar = ProgressBar.new()
var hp_bars : Array[ColorRect] = []
var bar_color : Array[Color] = [Color.RED,Color.BLUE_VIOLET,Color.YELLOW]
var y_pos : float = 400
var current_player : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,0.5)
	set_label_color()
	label_kr.size = Vector2(80,25)
	label_hp.size = Vector2(80,25)
	name_label.size = Vector2(270,25)
	hp_label.size = Vector2(130,25)
	for i in 3:
		var rect = ColorRect.new()
		rect.size.y = 20
		add_child(rect)
		hp_bars.append(rect)
	shield_bar.value = 100
	shield_bar.show_percentage = false
	shield_bar.max_value = 100
	shield_bar.min_value = 0
	shield_bar.size = Vector2(100,20)
	
	var st_fill = StyleBoxFlat.new()
	st_fill.bg_color = Color.LIME_GREEN
	var st_bg = StyleBoxFlat.new()
	st_bg.bg_color = Color.PURPLE
	
	shield_bar.add_theme_stylebox_override("background",st_bg)
	shield_bar.add_theme_stylebox_override("fill",st_fill)
	
	add_child(shield_bar)
	add_child(name_label)
	add_child(hp_label)
	add_child(label_hp)
	add_child(label_kr)
	
func set_label_color():
	var battle_color : Color = Global.current_fight.battle_color_theme
	var ui_color : Color = Global.players[current_player].color_theme*battle_color
	name_label.add_theme_color_override("default_color",ui_color)
	name_label.add_theme_font_override("normal_font",ui_font)
	name_label.add_theme_font_size_override("normal_font_size",22)
	
	hp_label.add_theme_color_override("default_color",ui_color)
	hp_label.add_theme_font_override("normal_font",ui_font)
	hp_label.add_theme_font_size_override("normal_font_size",22)
	
	label_hp.add_theme_color_override("default_color",ui_color)
	label_hp.add_theme_font_override("normal_font",ui_hp_font)
	label_hp.add_theme_font_size_override("normal_font_size",18)
	#label_hp.add_theme_constant_override("outline_size",3)
	
	label_kr.add_theme_color_override("default_color",ui_color)
	label_kr.add_theme_font_override("normal_font",ui_hp_font)
	label_kr.add_theme_font_size_override("normal_font_size",18)
	#label_kr.add_theme_constant_override("outline_size",3)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_labels()
	set_label_color()
	set_bars()
	set_shields_bar()

func set_labels():
	var off = 0 if !Global.players[current_player].kr else 40
	label_kr.visible = Global.players[current_player].kr
	name_label.position = Vector2(20,y_pos)
	hp_label.position = Vector2(320+hp_bars[0].size.x-30+off,y_pos)
	label_kr.position = Vector2(330+hp_bars[0].size.x-35,y_pos+2.5)
	label_hp.position = hp_bars[0].position + Vector2(-35,5)
	name_label.text = Global.players[current_player].Name + "   LV " + str(Global.players[current_player].LV)
	var hp_to_display = int(Global.players[current_player].hp) if !Global.players[current_player].kr else int(Global.players[current_player].kr_hp)
	hp_label.text = str(hp_to_display) +"/"+str(int(Global.players[0].max_hp))
	label_hp.text = "HP"
	label_kr.text = "KR"

func set_shields_bar():
	shield_bar.value = main.player.shield_amount
	shield_bar.visible = main.player.shield_active
	shield_bar.position = Vector2(500,400)
	
	var st_fill = shield_bar.get_theme_stylebox("fill")
	
	if main.player.shield_locked : st_fill.bg_color = Color.WHITE_SMOKE
	else: st_fill.bg_color = Color.LIME_GREEN
	
	shield_bar.add_theme_stylebox_override("fill",st_fill)

func set_bars():
	hp_bars[0].color = Global.players[current_player].hp_bars_color.background
	hp_bars[1].color = Global.players[current_player].hp_bars_color.karma
	hp_bars[2].color = Global.players[current_player].hp_bars_color.foreground
	hp_bars[0].size.x = Global.players[current_player].max_hp/0.82
	hp_bars[1].size.x = Global.players[current_player].kr_hp/0.82
	hp_bars[2].size.x = Global.players[current_player].hp/0.82
	hp_bars[1].visible = Global.players[current_player].kr
	for i in hp_bars.size():
		hp_bars[i].position.x = 280
		hp_bars[i].position.y = y_pos-2.5
