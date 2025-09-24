extends Node2D
class_name OWInteraction

signal interact

@export var player : OWPlayer = null
@export var textBox : OWBox
@export var dialogue : Array[String] = []

@onready var area_2d = $Area2D
var interacting : bool = false

var action : Callable = interaction :
	set(value):
		if interact.is_connected(action):
			interact.disconnect(action)
		
		action = value
		interact.connect(action)

func _ready():
	interact.connect(action)

func _process(_delta):
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body is OWPlayer:
			if Input.is_action_just_pressed("accept") and !player.lock:
				emit_signal("interact")
				interacting = true

func interaction():
	player.idle()
	player.velocity = Vector2.ZERO
	player.lock = true
	textBox.text.set_dialogue(dialogue,true)
	textBox.talk()
	textBox.text.dialogue_finished.connect(interaction_end)

func interaction_end():
	player.lock = false
	interacting = false
