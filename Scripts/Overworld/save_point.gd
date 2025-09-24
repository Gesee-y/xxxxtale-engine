extends Node2D

@export var text_box : OWBox
@export var canvas : CanvasLayer
@export var player : OWPlayer
@export var OW : Overworld
@export var dialogue : Array[String] = ["You are filled with [color=red]determination[/color]."]
@onready var interact = $OWInteraction

var SaveBox = preload("res://Objects/OW/save_box.tscn")
var appeared = false


# Called when the node enters the scene tree for the first time.
func _ready():
	interact.player = player
	interact.textBox = text_box
	interact.dialogue = dialogue
	interact.action = action

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func action():
	player.idle()
	player.velocity = Vector2.ZERO
	player.lock = true
	text_box.set_dialogue(dialogue,true)
	text_box.talk()
	await text_box.text.dialogue_finished
	var save = SaveBox.instantiate()
	interact.interacting = false
	save.player = player
	save.Ow = OW
	canvas.add_child(save)
