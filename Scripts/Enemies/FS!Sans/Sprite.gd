extends Node2D

@onready var legs = $Legs
@onready var torso = $Torso
@onready var head = $Torso/Head

var spd1:float = 3
var spd2:float = 6
var dis : float = 2
var dis2 : float = 2
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_throw_animation()
	if get_parent().can_wave:
		wave_body(delta)
	if torso.animation == "blood":
		wave_body2(delta)
		torso.offset = Vector2(-5,20)

func set_throw_animation():
	if torso.animation == "right" or torso.animation == "left":
		torso.offset = Vector2(30,27)
	elif torso.animation == "up" or torso.animation == "down":
		torso.offset = Vector2(10,0)
	else:
		torso.offset = Vector2.ZERO

func wave_body(delta):
	var siner = sin(timer*spd1)*dis
	var siner2 = sin(timer*spd2)*dis2
	torso.position.x = siner
	torso.position.y = -88 + siner2
	legs.material.set_shader_parameter("siner1",siner)
	timer += delta

func wave_body2(delta):
	var siner2 = sin(timer*spd2/4.0)*dis2
	torso.position.y = -88 + siner2
	timer += delta

func normal():
	head.frame = 1

func black_eye_1():
	head.frame = 0

func black_eye_2():
	head.frame = 5

func black_eye_3():
	head.frame = 7

func eye_closed():
	head.frame = 2

func look_right():
	head.frame = 3

func red_eye_nerfed():
	head.frame = 4

func red_eye_look_right():
	head.frame = 6

func black_eye_blood():
	head.frame = 8

func eye_closed_blood():
	head.frame = 9

func normal_blood():
	head.frame = 10

func look_right_blood():
	head.frame = 11


func _on_torso_animation_finished():
	torso.play("default")
