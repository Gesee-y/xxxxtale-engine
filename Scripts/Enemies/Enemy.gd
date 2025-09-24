extends Node2D
class_name Enemy

signal finish_talking(who)
signal act_finished(who)
signal Ready
signal dead
signal spared

@export_group("Enemy parameters")
@export var enemy_name:String = "Sans"
@export var xpos: float=320
@export var ypos: float = 250
@export var max_hp:int = 1000
@export var current_hp:int = 1000
@export var Atk : int = 10
@export var Def : int = 20
@export var Exp = 50
@export var Gold = 100
@export_enum("hit", "miss", "no effect") var mode = "hit"#change to "hit" if you want to make him get hit
@export var avoid_magic : bool = false
@export_subgroup("Battle SubData")
@export var show_healthbar : bool = false
@onready var writer : Writer = get_node("SpeechBubble/Writer")
@onready var bubble : NinePatchRect = get_node("SpeechBubble")
var attack : Array
@export var react_to_item : Dictionary
@export_group("Act Command")
@export var CheckDescription :Array[String]= [" * Sans 2 ATK 2 DEF \n The simplest enemy. ",
		" * Ready to make your life hell."]
var phase := 0
var text : Writer

@export var Act : Dictionary = {}

@export_group(" Enemy Dialogue")
@export var random_talk : bool = true
@export var Dialogue : Array[Array] = []
@export var main : BattleManager = null

var present = true
var Spared = false
var killed = false
var canSpare = false
var shake:float = 0
var item_to_react = ["d"]
var ReadyForBattle = false
var act_idx : Array[int] = []
var act_keys : Array = []
var id : int = 0
var collected = [false,false]
var siner : float = 0

func _ready():
	act_keys = Act.keys()
	GameFunc.ItemUsed.connect(object_reaction)
	if act_keys.size() > 0:
		act_keys.erase("Check")
		act_keys.insert(0,"Check")
	act_idx.resize(act_keys.size())

func _process(delta):
	siner+=delta*30.0
	if shake > 0:
		shake-=0.25
	position=Vector2(xpos+sin(siner*3.0)*shake,ypos)
	spare_condition()
	if Global.current_phase == Global.phase.ENEMY_EVENT:
		prepare_for_battle()
	if xpos > 0 and xpos < 640:
		present = true
	else :
		present = false
	if !still_alive() and !killed and !Spared:
		die()

func talk(_dialogue:Array,_can_pass:bool=true,_locked:bool=false,_size:Vector2 = Vector2.ZERO):
	writer.set_dialogue(_dialogue,false,_can_pass,_locked)
	if _size != Vector2.ZERO:
		bubble.size = _size
	writer.next_string()

func prepare_for_battle():
	if writer.is_string_availabe():
		ReadyForBattle = true
	else:
		if ReadyForBattle:
			ReadyForBattle = false
			emit_signal("Ready")

func acting(who,_command:String):
	if who.id == id:
		if _command == "Check":
			text.set_dialogue(CheckDescription,true)
			text.next_string()
			text.dialogue_finished.connect(func():emit_signal("act_finished",self))

func object_reaction(_item):
	if !Spared and !killed and enemy_name == "Blaster":
		if "Pie" in _item.serious_name:
			text.dialogue.append("Blaster seem to want some.")
		if "S.Apron" in _item.serious_name:
			text.dialogue.append("Blaster feel sorry for being the one who blast that child.")
			canSpare = true

func health_bar(_pos:Vector2,value,max_value,value_to_be):
	var timer = Timer.new()
	var twe = create_tween()
	var bar = ProgressBar.new()
	var back = StyleBoxFlat.new()
	var fill = StyleBoxFlat.new()
	bar.show_percentage = false
	bar.size = Vector2(200,10)
	bar.min_value = 0
	bar.global_position = _pos
	bar.max_value = max_value
	back.bg_color = Color(Color.RED,1.0)
	fill.bg_color = Color(Color.LIME,1.0)
	get_parent().add_child(bar)
	bar.add_child(timer)
	bar.value =value
	twe.tween_property(bar,"value",value_to_be,0.75).set_trans(Tween.TRANS_SINE)
	twe.finished.connect(Callable(timer,"start").bind(0.25))
	timer.timeout.connect(Callable(bar,"queue_free"))
	bar.add_theme_stylebox_override("background",back)
	bar.add_theme_stylebox_override("fill",fill)
	return bar

func damage_text(_damage,_position:Vector2):
	var color : Color
	var font : FontFile = preload("res://Resources/Fonts/hachicro.TTF")
	var damage_label : RichTextLabel = RichTextLabel.new()
	if _damage is String:
		color = Color.DARK_GRAY
	elif _damage == 0:
		color = Color.DARK_GRAY
	else :
		color = Color.RED
	damage_label.size = Vector2(400,60)
	damage_label.add_theme_color_override("default_color",color)
	damage_label.add_theme_font_override("normal_font",font)
	damage_label.add_theme_font_size_override("normal_font_size",30)
	damage_label.text = str(_damage)
	damage_label.modulate.a = 0
	get_parent().add_child(damage_label)
	var tween = create_tween()
	tween.set_parallel()
	damage_label.global_position.x = _position.x-(len(str(_damage)))*15
	damage_label.global_position.y = _position.y-30
	tween.tween_property(damage_label,"position:y",_position.y,.15).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(damage_label,"modulate:a",1,.15).set_trans(Tween.TRANS_BOUNCE)
	tween.chain()
	tween.tween_property(damage_label,"position:y",_position.y,.35)
	tween.tween_property(damage_label,"modulate:a",1,.35)
	tween.chain()
	tween.tween_property(damage_label,"position:y",_position.y-50,.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(damage_label,"modulate:a",0,.5).set_trans(Tween.TRANS_SINE)
	
	damage_label.z_index = 5
	return damage_label

func enemy_dodge(_animation:AnimatedSprite2D):
	var bpos = xpos
	var tween = create_tween()
	var dir = [-1,1].pick_random()
	tween.tween_property(self,"xpos",100*dir,0.75).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await _animation.animation_finished
	show_damage("MISS",bpos)
	await get_tree().create_timer(0.3).timeout
	var tween2 = create_tween()
	tween2.tween_property(self,"xpos",bpos,0.5).set_trans(Tween.TRANS_SINE)
	await tween2.finished
	ReadyForBattle = true

func show_damage(_damage,_xpos = 320):
	var off = 40
	if !(_damage is String):
		if _damage == 0:off = 80
		if !show_healthbar:
			health_bar(Vector2(global_position.x-100,global_position.y-80),
				current_hp,max_hp,current_hp-_damage)
		current_hp -= _damage
		shake = 5
		Global.sound_player.play_sfx("res://Sounds/SFX/hit.ogg")
	
	var dam = damage_text(_damage,Vector2(_xpos,position.y-off))
	await get_tree().create_timer(1).timeout
	dam.queue_free()

func still_alive():
	if current_hp > 0:
		return true
	
	return false

func die():
	killed = true
	emit_signal("dead",self)

func spare():
	Spared = true
	emit_signal("spared",self)

func fade(_duration=1):
	Global.sound_player.play_sfx("res://Sounds/SFX/Vaporise.wav")
	var tween = create_tween()
	tween.tween_property(self,"modulate:a",0,_duration)
	return tween

func spare_condition():
	if current_hp < (max_hp/4.0):
		canSpare = true
