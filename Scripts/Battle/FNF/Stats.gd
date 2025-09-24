extends Node
class_name FNFStats

var main : BattleManager

var score : int = 0 # The player Score
var misses : int = 0 # how many note were missed
var rating : float = 0 # The player accuracy
var longest_combo : int = 0 # The longest combo
var combo_score : int = 0 : # The current number of combo
	set(value):
		if value == 0:
			longest_combo = combo_score
		combo_score = value
var confront_value : Array[float] = [50.0,50.0]

var y_pos = 450

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in confront_value.size():
		var value = confront_value[i]
		value = clampf(value,0,100)
		confront_value[i] = value
	draw_hud()

func _on_scored(_score:int):
	score += _score

func draw_hud():
	if !Global.sound_player.now_playing.is_empty():draw_remaining_time()
	draw_score()
	draw_misses()
	draw_rating()
	draw_longest_combo()
	update_confront_bar()

func draw_remaining_time():
	var time_bar = has_child("Time Bar")
	var sound : AudioStreamPlayer = Global.sound_player.now_playing[main.battle.Sound]
	if time_bar == null:
		var label = create_label("Remaining",Vector2(130,-1.5))
		time_bar = create_bar("Time Bar",Vector2(180,10))
		time_bar.show_percentage = false
		time_bar.size = Vector2(300,20)
		time_bar.add_child(label)
	
	time_bar.get_child(0).text = convert_to_time(get_remaining_time()) # set the text of the label "Remaining" create above
	time_bar.value = sound.get_playback_position()
	time_bar.max_value = sound.stream.get_length()
	time_bar.min_value = 0

func draw_score():
	var label = has_child("Score")
	if label == null:
		label = create_label("Score",Vector2(70,y_pos))
		add_child(label)

	label.text = "Score : "+str(score)

func draw_misses():
	var label = has_child("Misses")
	if label == null:
		label = create_label("Misses",Vector2(190,y_pos))
		add_child(label)

	label.text = "Misses : "+str(misses)

func draw_rating():
	var label = has_child("Rating")
	if label == null:
		label = create_label("Rating",Vector2(290,y_pos))
		add_child(label)

	label.text = "Rating : %d(%s)"%[rating,get_rating(rating)]

func draw_longest_combo():
	var label = has_child("LCombo")
	if label == null:
		label = create_label("LCombo",Vector2(460,y_pos))
		add_child(label)

	label.text = "Longest Combo : "+str(longest_combo)

func update_confront_bar():
	var confront_bar = has_child("Confront Bar")
	if confront_bar == null:
		confront_bar = create_confront_bar()
	
	var enemy_bar = confront_bar.get_child(0)
	enemy_bar.size.y = 290 * confront_value[0]/100.0
	enemy_bar.position.y = -290*0.5+enemy_bar.size.y
	var player_bar = confront_bar.get_child(1)
	player_bar.size.y = 290 * confront_value[1]/100.0
	player_bar.position.y = 290*0.5-player_bar.size.y

func create_label(_name:String,_pos:Vector2) -> RichTextLabel:
	var label = RichTextLabel.new()
	label.size = Vector2(150,50)
	label.name = _name
	label.position = _pos
	return label

func create_bar(_name:String,_pos:Vector2) -> ProgressBar:
	var bar = ProgressBar.new()
	bar.name = _name
	bar.position = _pos
	var back_style = StyleBoxFlat.new()
	var fill_style = StyleBoxFlat.new()
	back_style.bg_color = Color.GRAY
	fill_style.bg_color = Color.AQUA
	bar.add_theme_stylebox_override("background",back_style)
	bar.add_theme_stylebox_override("fill",fill_style)
	add_child(bar)
	return bar

func create_confront_bar() -> Node2D:
	var confront_bar = Node2D.new()
	confront_bar.name = "Confront Bar"
	confront_bar.position = Vector2(20,230)
	var enemy_bar = ColorRect.new()
	var player_bar = ColorRect.new()
	enemy_bar.rotation_degrees = 180
	enemy_bar.position.x = 8
	enemy_bar.color = Color.AQUA
	enemy_bar.size.x = 8
	player_bar.color = Color.DARK_RED
	player_bar.size.x = 8
	confront_bar.add_child(enemy_bar)
	confront_bar.add_child(player_bar)
	add_child(confront_bar)
	return confront_bar

func has_child(_name:String):
	for child in get_children():
		if child.name == _name:
			return child
	
	return null

func get_remaining_time() -> float:
	var sound : AudioStreamPlayer = Global.sound_player.now_playing[main.battle.Sound]
	return sound.stream.get_length() - sound.get_playback_position()

func convert_to_time(_seconds:float) -> String:
	var minute = int(_seconds/60)
	var second = int(_seconds) % 60
	var zero = "0" if second < 10 else ""
	return str(minute)+":"+zero+str(second)

func get_rating(_rating:float) -> String:
	if _rating < 20:
		return "Wimp"
	elif _rating < 50:
		return "Too bad"
	elif _rating < 75:
		return "Good"
	elif _rating < 90:
		return "Nice"
	
	return "Sick"

func get_score_message(_score:int) -> String:
	if _score <= 100:
		return "Bad"
	elif _score <= 200:
		return "Good"
	
	return "Sick"
