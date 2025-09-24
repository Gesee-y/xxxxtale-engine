extends Enemy

@onready var torso = $Sprite/Torso
@onready var sprite = $Sprite
@onready var paps_sprite = $PapsSprite
@onready var phantom_paps = $PhantomPaps

var can_wave = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	#Global.display.fader.visible = false
	main.player.throwed.connect(throw)
	torso.play("default")
	writer.expres.connect(func(_exp):if sprite.has_method(_exp):Callable(sprite,_exp).call())
	
	sprite.torso_normal()
	sprite.normal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func throw(_dir:String):
	torso.play(_dir)
	sprite.set_throw_animation()
