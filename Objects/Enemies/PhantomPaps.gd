extends Node2D

var timer :float = 0.0

var spd1 : float = 4
var spd2 : float = 8

var dis : float = 1
var dis2 : float = 2

@onready var torso = $Torso
@onready var head = $Torso/Head
@onready var left_arm = $Torso/LeftArm
@onready var scarf = $Torso/Head/Scarf
@onready var right_arm = $Torso/RightArm
var convulsion = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if convulsion : convulse(delta)
	else : wave(delta)

func convulse(delta):
	var multiplier = 5.0
	var siner = sin(timer*spd1*multiplier)*dis/2.0
	var siner2 = sin(timer*spd2*multiplier)*dis2/2.0
	head.position = Vector2(-4+siner*2,-80+siner2*2)
	torso.position = Vector2(-siner,-siner2)
	timer += delta

func wave(delta):
	var multiplier = 1.0
	var siner = sin(timer*spd1*multiplier)*dis
	var siner2 = sin(timer*spd2*multiplier)*dis2
	
	var siner3 = sin(timer*spd1)*dis*10
	var siner4 = sin(timer*spd2*1.0)*dis2*3
	torso.position.x = siner3
	torso.position.y = siner4
	
	left_arm.position.x = -90 + siner*4.0
	right_arm.position.x = 77 + siner*4.0
	
	left_arm.position.y = -28 + siner2*1.5
	right_arm.position.y = -1 - siner2*2.0
	
	timer += delta
