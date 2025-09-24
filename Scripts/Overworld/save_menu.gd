extends Panel


var pos = [[35, 125], [242, 125]]
var menu_no = 0
var menu_coord = 0
@onready var text = $Manager/Save
@export var player : OWPlayer
@export var Ow : Overworld
@onready var soul = $Soul
@onready var manager = $Manager
var accept_buffer = 3
var saved = false
var appeared = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.lock = true
	size.y = 10
	
	position.y = -20
	$Manager/Name.text = Global.players[0].Name
	$Manager/Lv.text = "Lv %s" %[Global.Game_Data["LV"]]
	$Manager/Zone.text = Global.Game_Data["Location"]
	var tween = create_tween()
	tween.tween_property(self,"position:y",239,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel()
	tween.tween_property(self,"size:y",160,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position:y",175,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await(tween.finished)
	appeared = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player.lock = true
	if accept_buffer > 0:
		accept_buffer -= 30 * delta
	if visible and appeared:
		
		save_screen()


func save_screen():
	var accept = Input.is_action_just_pressed("accept")
	var cancel = Input.is_action_just_pressed("cancel")
	var menu_x = int(Input.is_action_just_pressed("right"))-int(Input.is_action_just_pressed("left"))
	if menu_no == 0:
		$Manager/Close.show()
		$Soul.show()
		if menu_x != 0:
			Global.sound_player.play_sfx("res://Sounds/SFX/menu_move.ogg")
			menu_coord = posmod(menu_coord + menu_x, 2)
		var i = menu_coord
		soul.position = Vector2(pos[i][0],pos[i][1])
		if cancel:
			close()
		if accept and accept_buffer <= 0:
			accept_buffer = 2
			if menu_coord == 0:
				Global.sound_player.play_sfx("res://Sounds/SFX/save.wav")
				menu_no = 1
			if menu_coord == 1:
				close()
	if menu_no == 1:
		if !saved:
			$Manager/Close.hide()
			$Soul.hide()
			text.text = "  File Saved."
			manager.modulate = Color(Color.YELLOW, 1.0)
			Global.Game_Data["SavePos"] = player.global_position
			Global.Game_Data["Location"] = Ow.RoomName
			Global.save_data()
			saved = true
			$Manager/Lv.text = "LV " + str(Global.Game_Data["LV"])
			$Manager/Zone.text = Global.Game_Data["Location"]
		if accept and accept_buffer <= 0:
			close()
func close():
	
	menu_no = 0
	menu_coord = 0
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self,"position:x",143+(357)/2.0,.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position:y",239,.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"size",Vector2(10,10),.5).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property(self,"position:y",-20,.5).set_trans(Tween.TRANS_SINE)
	await(tween.finished)
	player.lock = false
	saved = false
	visible = false
	queue_free()
