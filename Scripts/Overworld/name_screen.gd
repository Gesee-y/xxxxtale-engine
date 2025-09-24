extends Control

const CHARACTER_NUM = 62

var bad_names = ["sans", "mtt"]

# Called when the node enters the scene tree for the first time.
var init = false
var selected = 0
var letter_selected : RichTextLabel
var select_buffer = 0
var node
var string = ""
var screen_no = 0
var stringname = ""
var t_name
var selected_color = Color.YELLOW

var destination = "StartRoom"
var letters_Color = Color.WHITE
var letters_font = preload("res://Resources/Fonts/Determination Mono.ttf")

func _ready():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func Output_Letters(parent:Node,start_pos:Vector2):
	var current_position = start_pos
	var x_offset = 50
	var y_offset = 30
	
	var max_x = 560
	
	for i in CHARACTER_NUM:
		var switch_to_lowercase_condition = i >= 26
		var switch_to_number_condition = i >= 52
		
		var first_character_unicode = 65 # 95 represent the unicode A
		first_character_unicode = first_character_unicode if !switch_to_number_condition else 48 # 95 represent the unicode A
		
		var gaps_upper_lower = 6
		var gaps_lower_number = -52
		
		var plus = gaps_upper_lower if switch_to_lowercase_condition else 0
		plus = gaps_lower_number if switch_to_number_condition else plus
		
		var idx = i + plus
		var letter = String.chr(idx+first_character_unicode)
		
		var label = RichTextLabel.new()
		label.text = letter
		label.size = Vector2(50,50)
		label.position = current_position
		label.add_theme_color_override("default_color",letters_Color)
		label.add_theme_font_override("normal_font",letters_font)
		label.add_theme_font_size_override("normal_font_size",32)
		
		parent.add_child(label)
		
		if (current_position.x + x_offset) > max_x :
			current_position.x = start_pos.x
			current_position.y += y_offset
		else:
			current_position.x += x_offset
			
	var Back_label = RichTextLabel.new()
	Back_label.text = "Back"
	Back_label.size = Vector2(250,150)
	Back_label.position = Vector2(320,380)
	Back_label.add_theme_color_override("default_color",letters_Color)
	Back_label.add_theme_font_override("normal_font",letters_font)
	Back_label.add_theme_font_size_override("normal_font_size",32)
	
	parent.add_child(Back_label)
	var Enter_label = RichTextLabel.new()
	Enter_label.text = "Enter"
	Enter_label.size = Vector2(250,150)
	Enter_label.position = Vector2(450,380)
	Enter_label.add_theme_color_override("default_color",letters_Color)
	Enter_label.add_theme_font_override("normal_font",letters_font)
	Enter_label.add_theme_font_size_override("normal_font_size",32)
	parent.add_child(Enter_label)

func _process(delta):
	$Intro.text = "  [shake rate = 2 frequeny=0.2]%s[/shake]"%[string]
	$Name.text = "[shake rate = 2 frequeny=0.2]%s[/shake]"%[stringname]
	if select_buffer > 0:
		select_buffer -= 30 * delta
	
	if screen_no == 0:
		$Name.position = Vector2(272,72)
		$Name.scale = Vector2(1,1)
		$Name.visible = true
		if !init:
			init = true
			string = "Name the Fallen human"
			
			node = Node2D.new()
			node.visible = true
			add_child(node)
			
			Output_Letters(node,Vector2(100,120))
			select_next(selected)
	elif screen_no == 1:
		
		if !init:
			
			string =CheckName(stringname)
			if string == "!invalid":
				string = Get_bad_name(stringname)
				screen_no = 2
				select_buffer = 2
				init = false
			else :
				t_name = $Name.duplicate()
				add_child(t_name)
				$Name.visible = false
				var tween
				tween = create_tween()
				$ResetText.visible = true
				tween.set_parallel()
				$Intro.visible_ratio = 0.2
				tween.tween_property($Intro, "visible_ratio",1,2)
				tween.tween_property(t_name, "position:y", 240,5)
				tween.tween_property(t_name, "scale", Vector2(2,2),5)
			init = true
		if Input.is_action_just_pressed("cancel") and select_buffer <= 0:
			screen_no = 0
			init = false
			select_buffer = 2
			t_name.queue_free()
			reinitialize()
		if Input.is_action_just_pressed("left") and select_buffer<=0:
			selected -= 1
			select_buffer = 2
		if Input.is_action_just_pressed("right") and select_buffer<=0:
			selected += 1
			select_buffer = 2
		selected = posmod(selected,2)
		if selected == 0:
			$ResetText/No.add_theme_color_override("font_color",Color(selected_color,1.0))
			$ResetText/Yes.add_theme_color_override("font_color",Color(Color.WHITE,1.0))
		else :
			$ResetText/Yes.add_theme_color_override("font_color",Color(selected_color,1.0))
			$ResetText/No.add_theme_color_override("font_color",Color(Color.WHITE,1.0))
		if Input.is_action_just_pressed("accept") and select_buffer <= 0:
			if selected == 0:
				screen_no = 0
				t_name.queue_free()
				reinitialize()
				init = false
				select_buffer = 2
				deselect(selected)
				$Name.position = Vector2(224,88)
				$Name.scale = Vector2(1,1)
			if selected == 1:
				Global.players[0].Name = stringname
				Global.display.fade(Color.WHITE,G_Display.TYPE.IN,5)
				
				$Intro.visible = false
				await(get_tree().create_timer(5).timeout)
				if stringname.to_lower() == "gesee" : Global.current_fight = load("res://Resources/Battle/GB Fight.tres")
				
				GameFunc.ChangeRoom(destination)
				select_buffer = 2
	elif screen_no == 2:
		if !init:
			string = Get_bad_name(stringname)
			$Name.visible = false
			init = true
		if Input.is_action_just_pressed("accept") and select_buffer <= 0:
			reinitialize()

func _input(event):
	var vertical_offset = 10
	if screen_no == 0:
		if event.is_action_pressed("left") and selected > 0 and select_buffer <= 0:
			deselect(selected)
			selected -= 1
			select_next(selected)
			select_buffer = 2
		if event.is_action_pressed("right") and selected <= CHARACTER_NUM and select_buffer <= 0:
			deselect(selected)
			selected += 1
			select_next(selected)
			select_buffer = 2
		if event.is_action_pressed("up") and selected - 10>= 0 and select_buffer <= 0:
			deselect(selected)
			selected -= vertical_offset
			select_next(selected)
			select_buffer = 2
		if event.is_action_pressed("down") and selected +vertical_offset < CHARACTER_NUM and select_buffer <= 0:
			deselect(selected)
			selected += vertical_offset
			select_next(selected)
			select_buffer = 2
		elif event.is_action_pressed("down") and select_buffer <=0 and selected +vertical_offset >= CHARACTER_NUM:
			deselect(selected)
			selected = CHARACTER_NUM
			select_next(selected)
			select_buffer = 2
		if event.is_action_pressed("accept") and select_buffer <= 0:
			if letter_selected.text == "Enter" and len(stringname) > 0:
				node.visible = false
				screen_no = 1
				init = false
			elif letter_selected.text == "Back":
				delete_text()
			else:
				stringname = stringname+letter_selected.text
			select_buffer = 2

func select_next(idx):
	node.get_child(idx).add_theme_color_override("default_color",Color(Color.YELLOW,1.0))
	letter_selected = node.get_child(idx)

func deselect(idx):
	node.get_child(idx).add_theme_color_override("default_color",Color(Color.WHITE,1.0))
	
func delete_text():
	if len(stringname) > 0:
		var array = []
		for i in len(stringname):
			array.append(stringname[i])
		array.pop_back()
		stringname = "".join(array)
	
func reinitialize():
	init = false
	screen_no = 0
	select_buffer = 2
	selected = 0
	stringname = ""
	$Name.visible = true
	$ResetText.visible = false

func CheckName(Name):
	Name = Name.to_lower()
	if Name == "chara":
		return "The True name"
	elif Name == "frisk":
		return "This name will make you life hell\n           proceed?"
	elif Name == "kris":
		return "An Interesting coincidence"
	elif Name == "gesee":
		return "Someone is asking for a bad time!"
	elif "aaa" in Name:
		return "Not very creative"
	elif bad_names.has(Name):
		return "!invalid"
	else :
		return "Is this name correct?"

func Get_bad_name(badName):
	badName = badName.to_lower()
	if badName == "sans":
		return "nope"
	if badName == "mtt":
		return "Are you promoting my brand darling?"
