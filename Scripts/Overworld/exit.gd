extends Sprite2D
class_name OWExit

@export var Destination : String = ""
@export var entry_id : int = 0
@onready var exit_area = $ExitArea

func _ready():
	pass

func _process(_delta):
	pass

# When a body it an exit
func _on_exit_area_body_entered(body):
	# if it is the player then we change the room
	if body is OWPlayer:
		body.lock = true
		body.idle()
		body.velocity = Vector2.ZERO
		Global.ENTRY_POINT = entry_id
		Global.display.fade(Color.BLACK,G_Display.TYPE.IN,1)
		await get_tree().create_timer(1).timeout
		GameFunc.ChangeRoom(Destination)
