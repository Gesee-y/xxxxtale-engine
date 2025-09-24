extends Enemy

@onready var sprite = $Sprite
@onready var torso = $Sprite/Torso
@onready var head = $Sprite/Torso/Head

var finish : bool = false
var can_wave : bool = false

var how_many_laught : int = 0
var laught = [["You laught and say to Sans that monsterkind's fate is sealed.",
		"At this point he probably don't care"],
		["Useless.~He won't listen"]]

var remind = ["You take a moment to remember what you have gone through.",
		"Your will just get stronger."]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	main.player.throwed.connect(throw)
	torso.play("default")
	writer.expres.connect(func(_exp):if sprite.has_method(_exp):Callable(sprite,_exp).call())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !finish : super._process(delta)

func acting(who,_command:String):
	if who.id == id:
		if _command == "Check":
			text.set_dialogue(CheckDescription,true)
		if _command == "Laught":
			text.set_dialogue(laught[how_many_laught],true)
			how_many_laught = clampi(how_many_laught+1,0,1)
		if _command == "Remind":
			text.set_dialogue(remind,true)
		text.next_string()
		text.dialogue_finished.connect(func():emit_signal("act_finished",self))

func throw(_dir:String):
	torso.play(_dir)
	sprite.set_throw_animation()

func die():
	finish = true
	Global.sound_player.stop_all_music()
	head.frame = 7
	torso.play("blood")
	main.event_manager.turn=8
	can_wave = false
	Global.current_phase = Global.phase.NULL
