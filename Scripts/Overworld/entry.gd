extends Sprite2D
class_name OWEntry

@export var id : int = 0
@export_enum("left","right","up","down") var start_direction = "left"

@export var player : OWPlayer = null
var checked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !checked:
		if Global.ENTRY_POINT == id:
			player.global_position = global_position
			player.sprite.play(start_direction)
			Global.ENTRY_POINT = -1
		checked = true
