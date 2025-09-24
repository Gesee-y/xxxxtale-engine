extends Node
class_name G_Display

var canvas = CanvasLayer.new()
var fader = ColorRect.new()
var tween:Tween

enum TYPE{
	IN,
	OUT
}

#------------ Script ------------#

func _ready() -> void:
	fader.size = Vector2(1280,960)
	add_child(canvas)
	canvas.add_child(fader)
	fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.layer = 2
	fader.color = Color.BLACK

func fade(_color: Color = Color.BLACK,_type: TYPE = TYPE.IN,_duration: float=1.0) -> Tween:
	# We initialize the tweener 
	#so that we don't end with simultaneous tweening of the same object
	if tween != null:
		kill_current()
	
	tween = create_tween()
	
	# If the _type is IN then we made the canvas appears on the screen
	# If the _type is OUT then we made the canvas disappear
	
	if _type == TYPE.OUT:
		tween.tween_property(fader,"modulate:a",0.0,_duration).from(1.0)
	else:
		tween.tween_property(fader,"modulate:a",1.0,_duration).from(0.0)
		
	fader.color = _color #the canvas color will be the one entered in argument
	
	return tween

func click(_duration:float,_color:Color=Color.BLACK):
	fader.modulate.a = 1
	fader.color = _color
	fader.visible = true
	Global.sound_player.play_sfx("res://Sounds/SFX/flash.ogg")
	await get_tree().create_timer(_duration).timeout
	Global.sound_player.play_sfx("res://Sounds/SFX/flash.ogg")
	fader.modulate.a = 0

func kill_current() -> void:
	if tween.is_running():
		tween.kill()

#---------- End ----------#
