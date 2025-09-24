extends Node2D

@onready var legs = $Legs
@onready var torso = $Torso
@onready var head = $Torso/head
@onready var left_arm = $Torso/LeftArm

var spd1:float = 3
var spd2:float = 6
var dis : float = 2
var dis2 : float = 2
var timer : float = 0
var exicted = false

var torso_offset = Vector2.ZERO

var swing_time = 0
var swing_spd : float = 2.5
var swing = false :
	set(value):
		if value == true:
			torso_normal(exicted,true)
		swing = value
		swing_time = 0

var min_swing_time = 10
var max_swing_time = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_throw_animation()
	if swing:
		
		set_swing_animation(swing_time,min_swing_time,max_swing_time)
		swing_time += delta*60*swing_spd
		if swing_time > max_swing_time:
			torso_normal(exicted)
			swing = false
	if get_parent().can_wave:
		wave_body(delta)
	if torso.animation == "blood":
		wave_body2(delta)
		torso.offset = Vector2(-5,20)

func set_swing_animation(t:int,mi = 10,mx = 50):
	var torso_y = -73.3333
	
	if t < mi or t > mx-mi:
		if t < mi : torso.position.y = torso_y+3
		arm_down()
	elif t < (mx-mi)/2.0:
		torso.offset.y = -4
		arm_up()
	else:
		torso.offset.y = 0
		arm_swing()

func set_throw_animation():
	left_arm.visible = false
	if torso.animation == "right" or torso.animation == "left":
		var off = Vector2(29,-5)
		if (torso.animation == "right" && torso.frame == 0) || (torso.animation == "left" && torso.frame == 2):
			off.x = 32
		torso.offset = off
	elif torso.animation == "up" or torso.animation == "down":
		var off = Vector2(10,8)
		if (torso.frame == 1) : off.x = 19
		if (torso.animation == "up" && torso.frame == 0) || (torso.animation == "down" && torso.frame == 2):
			off.x = 6
		
		torso.offset = off

func wave_body(delta):
	var siner = sin(timer*spd1)*dis
	var siner2 = sin(timer*spd2)*dis2
	torso.position.x = -3.333 + torso_offset.x + siner
	torso.position.y = -73.3333 + torso_offset.y + siner2
	legs.material.set_shader_parameter("siner1",siner)
	timer += delta

func wave_body2(delta):
	var siner2 = sin(timer*spd2/4.0)*dis2
	torso.position.y = -73.3333 + siner2
	timer += delta

## ---------- Head Animation --------- ##

func normal():
	head.play("default")
	head.frame = 18

func black_eye_1():
	head.play("default")
	head.frame = 8

func black_eye_2():
	head.play("default")
	head.frame = 9

func black_eye_3():
	head.play("default")
	head.frame = 14

func black_eye_4():
	head.play("default")
	head.frame = 15

func white_eye_1():
	head.play("default")
	head.frame = 16

func white_eye_2():
	head.play("default")
	head.frame = 17

func white_eye_3():
	head.play("default")
	head.frame = 10

func cone_white_eye():
	head.play("default")
	head.frame = 23

func big_white_eye():
	head.play("default")
	head.frame = 22

func eye_closed():
	head.play("default")
	head.frame = 13

func look_right():
	head.play("default")
	head.frame = 20

func look_left():
	head.play("default")
	head.frame = 19

func exhausted():
	head.play("default")
	head.frame = 21

func red_eye_nerfed():
	head.play("default")
	head.frame = 5

func blue_eye_nerfed():
	head.play("default")
	head.frame = 4

func smile_1():
	head.play("default")
	head.frame = 0

func smile_2():
	head.play("default")
	head.frame = 6

func smile_blood_1():
	head.play("default")
	head.frame = 1

func smile_blood_2():
	head.play("default")
	head.frame = 7

func red_eye_look_right():
	head.play("default")
	head.frame = 6

func black_eye_blood():
	head.play("default")
	head.frame = 8

func eye_closed_blood():
	head.play("default")
	head.frame = 9

func normal_blood():
	head.play("default")
	head.frame = 10

func look_right_blood():
	head.play("default")
	head.frame = 11

## Excited

func ex_normal():
	head.play("excited")
	head.frame = 1

func ex_exhausted():
	head.play("excited")
	head.frame = 0

func ex_look_right():
	head.play("excited")
	head.frame = 2

func ex_look_left():
	head.play("excited")
	head.frame = 4

func ex_black_eye():
	head.play("excited")
	head.frame = 3

## What the ???

func aaah():
	head.play("Haha")
	head.frame = 1

func serious():
	head.play("Haha")
	head.frame = 0

## ---------- torso Animation --------- ##

func torso_normal(ex = false,knife=false):
	var off = Vector2.ZERO if !ex else Vector2(4,-2)
	var anim = "default" if !ex else "excited"
	var frame = 0 if !knife else 1
	if knife && !ex: off.y = -4
	
	left_arm.visible = knife
	
	torso.play(anim)
	torso.frame = frame
	torso.offset = off

func torso_excited():
	var offset = Vector2(5,-2)
	torso.play("excited")
	left_arm.visible = false
	torso.frame = 0
	torso.offset = offset

## ---------- LeftArm Animation --------- ##

func arm_down():
	var off = Vector2.ZERO
	left_arm.play("down")
	left_arm.offset = off

func arm_up():
	var off = Vector2(45,-45)
	left_arm.play("up")
	left_arm.offset = off

func arm_swing():
	var off = Vector2(20,-25)
	left_arm.play("swing")
	left_arm.offset = off

## ---------- Legs Animation --------- ##

func leg_normal():
	var off = Vector2.ZERO
	legs.play("normal")
	legs.offset = off

func leg_ex():
	var off = Vector2(-15,0)
	legs.play("excited")
	legs.offset = off

func leg_hit():
	var off = Vector2(-9,-3)
	legs.play("hitted")
	legs.offset = off

func _on_torso_animation_finished():
	torso_normal(exicted,false)
	torso_offset = Vector2.ZERO
