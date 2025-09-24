extends AttackManager
class_name AttackPattern

var box_pre : Vector2 = Vector2.ZERO
var attacks_manager : AttackManager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_attack():
	pass

func main_attack():
	pass

func attack_finished():
	pass



func angle_to_target(_pos, _target) -> float:
	var o = _target
	var p = o - _pos
	var angle = atan2(p.x,p.y)
	angle = -rad_to_deg(angle)
	return angle

func boomerang(node,_property:NodePath,init,final,duration,loop:int=0) -> Tween:
	var tween = create_tween()
	if loop > 0 : tween.set_loops(loop)
	tween.tween_property(node,_property, final,duration/2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(node,_property, init,duration/2.0).set_trans(Tween.TRANS_SINE)
	return tween
