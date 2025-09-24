extends Bullet

signal appeared
signal disappeared

@onready var bones = $Bones
@onready var crash_zone = $crashZone

var bone_inst = preload("res://Objects/Bullets/bone.tscn")
var bone_array : Array[Bullet] = []
var count : int = 10
var height : float = 80
var angle : float = 0
var gaps : float = 5
var alert : bool = true
var state : int = 0
var timer : float = 0
var wait : float = 50
var hold : float = 20

var appear : int = 0
var delay:int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	for i in count:
		var bone = bone_inst.instantiate()
		bone.offset_down = height
		bone.offset_top = 0
		bone.position = Vector2(i*(gaps+10),0)
		bone.type = type
		bones.add_child(bone)
	crash_zone.size.x = count*(gaps+10)
	crash_zone.size.y = height+13.0
	crash_zone.position.x -= 10
	crash_zone.global_position.y = bones.global_position.y-(height+25)

func _process(_delta):
	rotation_degrees = angle
	match appear:
		0:
			normal_appear()
		1:
			sine_appear()
		2:
			double_sine_appear()
		3:
			from_middle_appear()

func normal_appear():
	if state == 0 and !alert : state = 1
	match state:
		0:
			set_alert()
		1:
			crash_zone.visible = false
			bones.position.y = lerpf(bones.position.y,crash_zone.position.y,timer)
			timer += 1/15.0
			if timer >= 1:
				state = 2
				timer = 0
		2:
			hold_stab()
		3:
			disappear()

func sine_appear():
	if state == 0 and !alert : state = 1
	match state:
		0:
			set_alert()
		1:
			crash_zone.visible = false
			if int(timer) % delay == 0:
				@warning_ignore("integer_division")
				var child = bones.get_child(int(timer)/delay)
				if child != null:
					var twe = create_tween()
					twe.tween_property(child,"position:y",crash_zone.position.y,0.25).set_trans(Tween.TRANS_SINE)
			if int(timer) >= bones.get_child_count()*delay:
				state = 2
				timer = 0
			timer += 1
		2:
			hold_stab()
		3:
			disappear()

func double_sine_appear():
	if state == 0 and !alert : state = 1
	match state:
		0:
			set_alert()
		1:
			crash_zone.visible = false
			if int(timer) % delay == 0:
				@warning_ignore("integer_division")
				var child = bones.get_child(int(timer)/delay)
				@warning_ignore("integer_division")
				var last_child = bones.get_child(-(int(timer)/delay)-1)
				if child != last_child:
					if child != null:
						var twe = create_tween()
						twe.tween_property(child,"position:y",crash_zone.position.y,0.25).set_trans(Tween.TRANS_SINE)
					if last_child != null:
						var twe = create_tween()
						twe.tween_property(last_child,"position:y",crash_zone.position.y,0.25).set_trans(Tween.TRANS_SINE)
				else:
					state = 2
					timer = 0
			timer += 1
		2:
			hold_stab()
		3:
			disappear()

func from_middle_appear():
	if state == 0 and !alert : state = 1
	match state:
		0:
			set_alert()
		1:
			crash_zone.visible = false
			if int(timer) % delay == 0:
				@warning_ignore("integer_division")
				
				var middle = (bones.get_child_count())/2
				@warning_ignore("integer_division")
				var child = bones.get_child(middle + int(timer)/delay)
				@warning_ignore("integer_division")
				var last_child = bones.get_child(middle-(int(timer)/delay)) if timer > 0 else null
				if child != null:
					var twe = create_tween()
					twe.tween_property(child,"position:y",crash_zone.position.y,0.25).set_trans(Tween.TRANS_SINE)
				if last_child != null:
					var twe = create_tween()
					twe.tween_property(last_child,"position:y",crash_zone.position.y,0.25).set_trans(Tween.TRANS_SINE)
			timer += 1
			@warning_ignore("integer_division", "integer_division", "integer_division", "integer_division", "integer_division", "integer_division")
			if int(timer) >= (bones.get_child_count()+1/2)*delay:
				state = 2
				timer = 0
		2:
			hold_stab()
		3:
			disappear()

# ---------- Stab Effect -----------#

func up_down(_to:float=20,_dur:float = 0.5):
	for i in bones.get_child_count():
		var twes = create_tween()
		twes.set_loops(100)
		var bo = bones.get_child(i)
		if bo != null:
			if i % 2 == 0:
				twes.tween_property(bo,"offset_top",_to,_dur).set_trans(Tween.TRANS_SINE)
				twes.tween_property(bo,"offset_top",0,_dur).set_trans(Tween.TRANS_SINE)
			else:
				twes.tween_property(bo,"offset_top",0,_dur).set_trans(Tween.TRANS_SINE)
				twes.tween_property(bo,"offset_top",_to,_dur).set_trans(Tween.TRANS_SINE)

func sine_fx(_to:float = 30,_dur:float = 1,_delay:float = 0.05):
	for i in bones.get_child_count():
		var twes = create_tween()
		twes.set_loops(100)
		var bo = bones.get_child(i)
		if bo != null:
			twes.tween_property(bo,"offset_top",_to,_dur).set_trans(Tween.TRANS_SINE)
			twes.tween_property(bo,"offset_top",0,_dur).set_trans(Tween.TRANS_SINE)
			await get_tree().create_timer(_delay).timeout

func set_alert():
	if timer == 0:
		Global.sound_player.play_sfx("res://Sounds/SFX/warning.ogg")
	crash_zone.visible = true
	if timer < wait:
		crash_zone.modulate = Color.RED if int(timer) %5 ==0 else Color.YELLOW
		timer += 1
	else:
		emit_signal("appeared")
		state = 1
		timer = 0

func disappear():
	bones.position.y = lerpf(bones.position.y,crash_zone.position.y+height*3.0,timer)
	timer += 1/15.0
	if timer >= 1:
		emit_signal("appeared")
		queue_free()

func hold_stab():
	timer += 1
	if timer >= hold: 
		timer = 0
		state += 1
