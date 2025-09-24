extends Camera2D
class_name BattleCamera

@export var xpos = 320.0
@export var ypos = 240.0
@export var ind_xpos = 0.0
@export var ind_ypos = 0.0
var shake = 0.0
var shake_spd = 3.0
var always = false
var angle = 0
var siner=0
var offX : float = 0
var offY : float = 0
var beat : int = 50
var beat_amp : float = 1.2
var timer : int = 0
var can_beat : bool = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if offX != 0:
		offX = move_toward(offX,0,delta*3)
	if offY != 0:
		offY = move_toward(offY,0,delta*3)
	if timer % beat == 0 and can_beat:
		zoom*=beat_amp
		create_tween().tween_property(self,"zoom",Vector2(1,1),0.25).set_trans(Tween.TRANS_SINE)

	siner += delta*30
	rotation_degrees = angle
	offset.x = ind_xpos+xpos+sin(shake_spd*siner/1)*shake+offX
	offset.y = ind_ypos+ypos+sin(shake_spd/1*siner/2)*shake+offY
	if shake >0 and always == false:
		shake-=0.25
	if can_beat:timer += 1
