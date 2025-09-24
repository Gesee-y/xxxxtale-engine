extends Node2D

@onready var NameText = $Container/name
@onready var timeText =$Container/Time
@onready var lvText =$Container/Lv
@onready var locText = $Container/Location
@onready var container = $Container
var init = false
var selected = 0
var selection
var select_buffer = 0
var screen_no = 0
signal loaded
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,0.05)
	Global.load_data()

var text_init = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if select_buffer > 0:
		select_buffer-= 30*delta
	if !text_init:
		text_init = true
	if screen_no ==0:
		NameText.text = Global.Game_Data.Name
		lvText.text = "LV " + str(Global.Game_Data["LV"])
		locText.text = Global.Game_Data["Location"]
		if !init:
			selected = 0
			container.visible = true
			$Credit.visible = true
			$ResetText.visible = false
			$BG.visible = true
			init = true
			select_next(selected)
		if Input.is_action_just_pressed("left") and select_buffer <=0:
			move(selected,-1)
		if Input.is_action_just_pressed("right") and select_buffer <=0:
			move(selected,1)
		selected = posmod(selected,2)
		if Input.is_action_just_pressed("accept") and select_buffer <= 0:
			if selected == 0:
				GameFunc.ChangeRoom(Global.Game_Data.Location)
			else:
				screen_no = 1
				select_buffer=2
				text_init = false
				init = false
	elif screen_no == 1:
		if !init:
			container.visible = false
			$Credit.visible = false
			$ResetText.visible = true
			$BG.visible = false
			var tween = create_tween()
			tween.set_parallel()
			tween.tween_property($ResetText/Name, "position:y", 240,5)
			tween.tween_property($ResetText/Name, "scale", Vector2(2,2),5)
			selected = 0
			init = true
		if Input.is_action_just_pressed("left") and select_buffer<=0:
			selected -= 1
			select_buffer = 2
		if Input.is_action_just_pressed("right") and select_buffer<=0:
			selected += 1
			select_buffer = 2
		selected = posmod(selected,2)
		if selected == 0:
			$ResetText/No.add_theme_color_override("font_color",Color(Color.YELLOW,1.0))
			$ResetText/Yes.add_theme_color_override("font_color",Color(Color.WHITE,1.0))
		else :
			$ResetText/Yes.add_theme_color_override("font_color",Color(Color.YELLOW,1.0))
			$ResetText/No.add_theme_color_override("font_color",Color(Color.WHITE,1.0))
		if Input.is_action_just_pressed("accept") and select_buffer <= 0:
			if selected == 0:
				screen_no = 0
				init = false
				text_init = false
				select_buffer = 2
				deselect(selected)
				$ResetText/Name.position = Vector2(224,88)
				$ResetText/Name.scale = Vector2(1,1)
			if selected == 1:
				GameFunc.ChangeRoom("NameScreen")
func select_next(idx):
	container.get_child(idx+4).add_theme_color_override("font_color",Color(Color.YELLOW,1.0))
	selection = container.get_child(idx+4)

func move(selected:int,dir:int):
	deselect(selected) 
	selected +=dir
	selected = posmod(selected,2)
	select_next(selected)
	select_buffer=2

func deselect(idx):
	selection.add_theme_color_override("font_color",Color(Color.WHITE,1.0))
