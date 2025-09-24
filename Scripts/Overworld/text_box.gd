extends NinePatchRect
class_name OWBox

@export var overworld : Overworld = null
@onready var text : Writer = $Writer
var active : bool = false
var y_pos : Array[float] = [304,20]


# Called when the node enters the scene tree for the first time.
func _ready():
	close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_talking() and !active:
		open()
	if !is_talking() and active:
		close()

func is_talking():
	return !text.stop

func set_dialogue(_dialogue:Array,_asterisk : bool = false,can_pass:bool = true,locked:bool = false):
	text.set_dialogue(_dialogue,_asterisk,can_pass,locked)

func talk():
	open()
	position.y = y_pos[int((overworld.player.position.y-overworld.camera.position.y) >= 240)]
	text.next_string()

func open():
	active = true
	visible = true

func close():
	active = false
	visible = false
	text.end_writer()
