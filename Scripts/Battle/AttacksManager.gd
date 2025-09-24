extends Node2D
class_name AttackManager

signal attack_ended
signal new_flow_arrow_player(_arr)
signal new_flow_arrow_bot(_dir:String,_spd:float)

var bullet_list = Instantier.new()
var main : BattleManager = null
var mask : Polygon2D = null
var box : Box = null
var player:PlayerSoul = null
var current_attack : AttackPattern = null
var pattern = ["res://Scripts/AttacksPatterns/Test/attack_intro.gd"]
var heal_pattern = []
var attack_start : bool = false
var type : String = "attack"
var random_attack : bool = false
var blaster_type : Dictionary = {
	"Classic" : load("res://Resources/Blasters/Classic.tres"),
	"FS" : load("res://Resources/Blasters/FS.tres"),
	"Dust" : load("res://Resources/Blasters/Dust.tres")
}

func set_attack(_script:String):
	var node2d = AttackPattern.new()
	node2d.set_script(load(_script))
	add_child(node2d)
	current_attack = node2d
	return node2d

func pre_attack():
	var atk_idx = main.event_manager.turn if !random_attack else randi_range(0,pattern.size()-1)
	if type.to_lower() == "attack":set_attack(pattern[atk_idx])
	else : 
		if heal_pattern.size() > 0:set_attack(heal_pattern[atk_idx])
		else : current_attack = null
	if current_attack != null:
		current_attack.attacks_manager = self
		current_attack.player = player
		current_attack.box = box
		current_attack.mask = mask
		current_attack.main = main
		player.global_position = box.center
		current_attack.pre_attack()
		player.velocity = Vector2.ZERO
		if current_attack.box_pre != Vector2.ZERO:
			var tween = create_tween()
			tween.set_parallel(true)
			tween.tween_property(box,"xscale",current_attack.box_pre.x,0.65).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			tween.tween_property(box,"yscale",current_attack.box_pre.y,0.65).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			await tween.finished

func start_attack():
	if current_attack != null:
		player.lock = false
		player.visible = true
		current_attack.main_attack()
		attack_start = true
	else:
		attack_end()
		main.menu_timer = 0.95

func attack_end():
	if current_attack != null : current_attack.attack_finished()
	clear_attack()
	main.reset()
	box.can_push = ""
	player.lock = true
	player.shield_locked = false
	box.bg.color = Color.BLACK
	if box.form != "rect":
		box.set_form("rect",1/20.0)
		player.position=box.center
		await box.resize_finished
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(box,"xscale",0,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(box,"yscale",0,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(box,"xpos",0,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(box,"ypos",0,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(box,"angle",0,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	emit_signal("attack_ended")
	attack_start = false

func clear_mask(_everything:bool=false):
	for object in mask.get_children():
		if object is Bullet:
			if _everything : object.queue_free()
			else : if !object.no_clear : object.queue_free()
		if object is Plateform:
			object.queue_free()

func clear_attack(_everything:bool=false):
	clear_mask(_everything)
	for i in get_children():
		i.queue_free()

# ---------- Fire Section ----------- #

func fire(_position:Vector2,_xspd:float,_yspd:float,_hide:float = false,_angle:float = 0,_type:int=0,_default:bool = true):
	var i : Bullet= get_bullet("res://Objects/Bullets/bullet_test.tscn").instantiate()
	i.position = _position
	i.rotation_degrees = _angle
	i.xspeed = _xspd
	i.yspeed = _yspd
	i.type = _type
	i.masked = _hide
	if _default : mask.add_child(i)
	return i

func fire_circle(pos:Vector2,_type:int,_count,radius:float,spd:float,_hide:bool=false):
	var node = Bullet.new()
	node.position = pos
	mask.add_child(node)
	for i in _count:
		var _angle = i * (TAU / float(_count))
		var ang = _angle + PI/2.0
		var xpos = cos(_angle) * radius
		var ypos = sin(_angle) * radius
		var posi = Vector2(xpos,ypos)
		
		var fir = fire(posi,cos(ang)*spd,sin(ang)*spd,_hide,rad_to_deg(ang-PI/2.0),_type,false)
		fir.offs = false
		node.add_child(fir)
	
	return node

# ------------ Blaster Section ---------------#

func gaster_blaster(_start:Vector2,_end:Vector2,_angle:float,_size:float=1,_type:int=0,
		_wait:float=5,_hold:float=5,_spd:float = 2,style:BlasterData = blaster_type["Classic"]):
	var i : Bullet= get_bullet("res://Objects/Bullets/gaster_blaster.tscn").instantiate()
	i.style = "blast"
	i.xscale= _size
	i.type = _type
	i.hold= _hold
	i.blaster_res = style
	i.spd= _spd
	i.start_pos=_start
	i.pos= _end
	i.angle= _angle
	i.wait= _wait
	i.masked = false
	mask.add_child(i)
	return i

func fs_gaster_blaster(_start:Vector2,_end:Vector2,_angle:float,_size:float=1,_type:int=0,
		_wait:float=5,_hold:float=5,_spd:float = 2):
	var i : Bullet = gaster_blaster(_start,_end,_angle,_size,_type,_wait,_hold,_spd,blaster_type["FS"])
	return i

func dust_gaster_blaster(_start:Vector2,_end:Vector2,_angle:float,_size:float=1,_type:int=0,
		_wait:float=5,_hold:float=5,_spd:float = 2):
	var i : Bullet = gaster_blaster(_start,_end,_angle,_size,_type,_wait,_hold,_spd,blaster_type["Dust"])
	return i

func gaster_crasher(_end:Vector2,_angle:float,_size:float=1,_type:int=0,
		_wait:float=10,_spd:float = 2,style = blaster_type["Classic"]):
	var i : Bullet= get_bullet("res://Objects/Bullets/gaster_blaster.tscn").instantiate()
	i.style = "crash"
	i.xscale= _size
	i.type = _type
	i.spd= _spd
	i.pos= _end
	i.angle= _angle
	i.blaster_res = style
	i.wait= _wait
	i.masked = false
	mask.add_child(i)
	return i

# ------------ Bone Section ----------------#

func bone(_pos:Vector2,_type:int,_angle:float,_offset:Vector2,_xspd:float,_yspd:float,_hide:bool,default:bool=true):
	var i= get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
	i.position = _pos
	i.type = _type
	i.offset_top = _offset.x
	i.offset_down = _offset.y
	i.angle = _angle
	i.masked = _hide
	i.yspeed = _yspd
	i.xspeed = _xspd
	if default : mask.add_child(i)
	return i

func paps_bone(_pos:Vector2,_type:int,_angle:float,_offset:Vector2,_xspd:float,_yspd:float,_hide:bool,default:bool=true):
	var i= get_bullet("res://Objects/Bullets/bone.tscn").instantiate()
	i.position = _pos
	i.type = _type
	i.paps = true
	i.offset_top = _offset.x
	i.offset_down = _offset.y
	i.angle = _angle
	i.masked = _hide
	i.yspeed = _yspd
	i.xspeed = _xspd
	if default : mask.add_child(i)
	return i

func bone_stab(_pos:Vector2,_type:int,_angle:float,_count:int = 12,_height:float=30,_wait:float = 15,_hold:float=30,_gaps:float = 5,_alert:bool = true,_appear_style:int=0):
	var i = get_bullet("res://Objects/Bullets/bone_stab.tscn").instantiate()
	i.position = _pos
	i.type = _type
	i.angle = _angle
	i.count = _count
	i.gaps = _gaps
	i.height = _height
	i.alert = _alert
	i.wait = _wait
	i.hold = _hold
	i.appear = _appear_style
	i.masked = true
	mask.add_child(i)
	return i

func bone_circle(_pos:Vector2,_radius:float,_type:int,_bone_count:int,_ang_spd:float,_size:float,_xspd:float,_yspd:float,_hide:bool,_mode:int=0):
	var i= get_bullet("res://Objects/Bullets/bone_circle.tscn").instantiate()
	i.create_mode = _mode
	i.position = _pos
	i.type = _type
	i.radius = _radius
	i.bone_count= _bone_count
	i.bone_size = _size
	i.ang_spd = _ang_spd
	i.masked = _hide
	i.yspeed = _yspd
	i.xspeed = _xspd
	mask.add_child(i)
	return i

func bone_polygon(_pos:Vector2,_radius:float,_type:int,_side:int,_ang_spd:float,_xspd:float,_yspd:float,_hide:bool):
	var i = bone_circle(_pos,_radius,_type,_side,_ang_spd,0,_xspd,_yspd,_hide,1)
	return i

# ------------- Plateform Section ---------------#

func plateform(_pos:Vector2,_type:int,_angle:float,_size:float,_speed:Vector2,_hide:bool = true):
	var i = get_bullet("res://Objects/Bullets/plateform.tscn").instantiate()
	i.position = _pos
	i.type = _type
	i.angle = _angle
	i.xspeed = _speed.x
	i.yspeed = _speed.y
	i.xscale = _size
	i.masked = _hide
	mask.add_child(i)
	return i

# ------------ Arrows Section --------------#
func arrow(_dir:String,_spd:float=3,_style:int=0):
	var i = get_bullet("res://Objects/Bullets/arrow.tscn").instantiate()
	i.direction = _dir
	i.spd = _spd
	i.style = _style
	i.masked = false
	i.global_position = player.global_position
	mask.add_child(i)
	return i

func flow_arrow_p(_dir:String,_spd:float=3,_style:int=0):
	var arr = arrow(_dir,_spd,_style)
	emit_signal("new_flow_arrow_player",arr)

func flow_arrow_b(_dir:String,_spd:float=3):
	emit_signal("new_flow_arrow_bot",_dir,_spd)

# --------------- Spears Section ------------- #

func spear(pos:Vector2,xspd:float,yspd:float,_hide:bool):
	var i = get_bullet("res://Objects/Bullets/spear.tscn").instantiate()
	i.position = pos
	i.xspeed = xspd
	i.yspeed = yspd
	i.masked = _hide
	mask.add_child(i)
	
	return i

func asgore_spear(pos:Vector2,_angle:float,xspd:float,yspd:float,_hide:bool):
	var i = get_bullet("res://Objects/Bullets/a_spear.tscn").instantiate()
	i.position = pos
	i.rotation_degrees = _angle
	i.xspeed = xspd
	i.yspeed = yspd
	i.masked = _hide
	mask.add_child(i)
	
	return i

func get_bullet(_path:String) -> PackedScene:
	if !bullet_list.has_object(_path):
		bullet_list.add_to_list(_path,load(_path))
	
	return bullet_list.get_object(_path)
