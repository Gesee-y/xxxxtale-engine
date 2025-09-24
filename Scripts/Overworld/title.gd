extends Node2D

var init = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,0.01)
	await get_tree().create_timer(5).timeout
	#if FileAccess.file_exists(Global.save_file):
	#	GameFunc.ChangeRoom("LoadScreen")
	#else:
	GameFunc.ChangeRoom("NameScreen")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
		
