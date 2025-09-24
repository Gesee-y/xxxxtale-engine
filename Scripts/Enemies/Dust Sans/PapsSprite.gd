extends Node2D

var timer :float = 0.0

var spd1 : float = 4
var spd2 : float = 8

var dis : float = 1
var dis2 : float = 1

@onready var legs = $Legs
@onready var torso = $Torso
@onready var rigth_arm = $Torso/RigthArm

var torso_offset : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wave_body(delta)

func wave_body(delta):
	var siner = sin(timer*spd1)*dis
	var siner2 = sin(timer*spd2)*dis2
	rigth_arm.rotation_degrees = siner2*2
	torso.position.x = 2 + torso_offset.x + siner
	torso.position.y = -40 + torso_offset.y + siner2
	legs.material.set_shader_parameter("siner1",siner)
	timer += delta
