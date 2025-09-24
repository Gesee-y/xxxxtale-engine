extends RichTextLabel
class_name Writer

const TEXT_MULTIPLIER = 4
@export var typer : TyperData
signal dialogue_finished
signal string_finished
signal expres(_exp:String)

var Functions = RegFunc.new()
var string : String = ""
var cleaned : String = ""
var char_count : float = 0
var text_box_size : Vector2 = Vector2(562,110):
	set(value):
		size = value
		text_box_size = value

var dialogue : Array = []
var current_string : int = -1
var can_write : bool = false
var stop : bool = true
var asterisk : bool = true
var face_margin : int = 40
var face : AnimatedSprite2D = null

var function_call : Dictionary
var marker : Dictionary = {
	"{P":"pause",
	"{S":"speed",
	"{D":"delay",
	"{l":"lock",
	"{s":"skip"
}
var writer_events : Dictionary={
	"pause":0.0,
	"speed":5.0,
	"delay":0,
	"lock":0,
	"skip":1
}

var Typers : Dictionary = {
	"default" : load("res://Resources/Typers/Default.tres"),
	"sans" : load("res://Resources/Typers/Sans.tres"),
	"papyrus" : load("res://Resources/Typers/Papyrus.tres")
}

var punctuation : Dictionary = {
	[","]:.3,
	[";"]:.5,
	[".","?","!"]:.7
}

var events : Array[Array]=[]

func _ready():
	bbcode_enabled = true
	scroll_active = false
	visible_characters = 0
	size = text_box_size

func _process(_delta):
	if !finish_writing():
		can_write = true
	else :
		if Input.is_action_just_pressed("accept") and !bool(writer_events["lock"]):
			next_string()
		can_write = false
	if can_write:
		if Input.is_action_just_pressed("cancel") and bool(writer_events["skip"]):
			char_count = string.length()
			visible_characters = char_count
			reset_writer_events()
		call_writer_events()
		set_text_parameters(typer.color,typer.text_font,typer.font_size,
				typer.shadow_offset,typer.shadow_color)
		if writer_events["pause"] <=0:
			write_text(_delta*TEXT_MULTIPLIER)
			call_functions()
		else:
			writer_events["pause"] -= _delta*TEXT_MULTIPLIER

func write_text(_delta) -> void:
	text = string
	char_count += _delta * writer_events["speed"]
	if int(char_count) % (writer_events["delay"]+1)==0:
		var last_count = visible_characters
		visible_characters = int(char_count)
		if visible_characters < cleaned.length():
			if ((last_count != visible_characters) or writer_events["delay"] > 2) and string[visible_characters]!=" ":
				Global.sound_player.play_sfx(typer.sound_path)
				if (punctuation.has([string[visible_characters-1]]) or string[visible_characters-1] in [".","!","?"]):
					writer_events["pause"] = punctuation.get([string[visible_characters-1]],punctuation[[".","?","!"]])

func next_string():
	if is_string_availabe():
		clear_text()
		reset_writer_events()
		stop = false
		current_string +=1
		string = dialogue[current_string] + " "
		clean_text()
	elif !stop:
		emit_signal("dialogue_finished")
		end_writer()

func assign_function_call(_char_count:int,_string_idx:int,_function:Callable):
	function_call[[_string_idx,_char_count]] = _function

func call_functions():
	if !function_call.is_empty():
		var keys : Array= function_call.keys()
		for key in keys:
			if key[0] == current_string:
				if key[1] <= char_count:
					function_call[key].call()
					function_call.erase(key)

func call_writer_events():
	for event in events:
		if int(char_count) == event[0]:
			writer_events[event[1]] = event[2]
			events.erase(event)

func clean_text():
	var _idx = 0
	var _index = 0
	var char_per_line : int = (text_box_size.x / get_theme_default_font_size())+typer.char_count_offset
	var return_pos :Array[int] = []
	if string[0]=="{":
		var _typer : String = Functions.get_str_between(string,"{",":")
		var expression = Functions.get_str_between(string,":","}")
		set_typer(_typer,expression)
		expres.emit(expression)
		string = string.replace("{"+_typer+":"+expression+"}","")
	else:
		set_typer("default")
	cleaned = Functions.remove_bb_code(string)
	
	if asterisk : 
		string = " * " + string
		cleaned = " * " + cleaned
	
	return_pos = Functions.find_occurence(cleaned,"~")
	cleaned = cleaned.replace("~","\n * ") if asterisk else cleaned.replace("~","\n")
	string = string.replace("~","\n * ") if asterisk else string.replace("~","\n")
	tab_size = typer.tab_lenght
	while _idx < cleaned.length()-1:
		var mark = cleaned[_idx]+cleaned[_idx+1]
		
		if return_pos.size() > 0:
			if _idx == return_pos[0]:
				return_pos.pop_front()
				_index = 0
		
		if asterisk and (_index) % char_per_line == 0 and _index != 0 and !("\n" in mark):
			var _p = cleaned.rfind(" ",_idx)
			var _pos = Functions.find_position_with_bb(cleaned,string,_p)
			string = string.insert(_pos,"\n	")
			cleaned = cleaned.insert(_pos,"\n	")
		
		if marker.has(mark):
			var value = Functions.get_number_from_string(cleaned,_idx+2)
			events.append([_idx,marker[mark],value])
			cleaned = Functions.replace_one(cleaned,mark+str(value)+"}","")
			string = Functions.replace_one(string,mark+str(value)+"}","")
		
		_idx += 1
		_index+=1
	cleaned = Functions.remove_bb_code(string)

func set_typer(_typer,_face_expression = "normal"):
	typer = Typers.get(_typer,Typers["default"])
	if typer.face_included: 
		set_face()
		face.animation = _face_expression
	else:
		unset_face()

func set_dialogue(_dialogue:Array,_asterisk : bool = false,can_pass:bool = true,locked:bool = false):
	reset_writer()
	set_text_advance(bool(locked),bool(can_pass))
	asterisk = _asterisk
	dialogue = _dialogue

func set_text_parameters(_color:Color,_font:Font,_font_size:int,_shadow_offset:Vector2,_shadow_color:Color):
	add_theme_color_override("default_color",_color)
	add_theme_font_override("normal_font",_font)
	add_theme_font_size_override("normal_font_size",_font_size)
	if _shadow_offset != Vector2.ZERO:
		add_theme_color_override("font_shadow_color",_shadow_color)
		add_theme_constant_override("shadow_offset_x",_shadow_offset.x)
		add_theme_constant_override("shadow_offset_y",_shadow_offset.y)

func set_face():
	if face == null:
		face = AnimatedSprite2D.new()
		get_parent().add_child(face)
		face.sprite_frames = typer.face_sprite_frame
		face.position = position+Vector2(-10,35)
		face.scale *= 2
		position.x += face_margin
		text_box_size.x -= face_margin

func unset_face():
	if face != null:
		face.queue_free()
		position.x -= face_margin
		text_box_size.x += face_margin

func is_string_availabe() -> bool:
	if current_string +1 >= dialogue.size():
		return false
	
	return true

func finish_writing() -> bool:
	if char_count+1/60.0 > cleaned.length():
		if can_write:
			emit_signal("string_finished")
		return true
	
	return false

func clear_text():
	visible_characters = 0
	char_count = 0
	string = ""
	cleaned = ""
	text = ""

func reset_writer():
	clear_text()
	reset_writer_events()
	set_text_advance()
	unset_face()
	current_string = -1
	dialogue = []

func reset_writer_events():
	writer_events["pause"] = 0
	writer_events["speed"] = 5
	writer_events["delay"] = 0

func set_text_advance(_lock:bool=false,_skip:bool=true):
	writer_events["lock"] = _lock
	writer_events["skip"] = _skip

func end_writer():
	reset_writer()
	stop = true
