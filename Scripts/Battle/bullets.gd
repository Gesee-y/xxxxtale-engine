extends Node2D
class_name Bullet

var type : int = 0
@export var damage : float = 0
@export var b_curse : float = 0

var area2d : Area2D
var rotation_speed = 0
var exited = false
var xspeed : float= 0
var yspeed :float = 0
var type_color = [Color.WHITE,
		Color.CYAN,
		Color.ORANGE,
		Color.YELLOW,
		Color.GOLD,
		Color(0.92941176891327, 0, 0.11372549086809)]

# Interpolation var
var target : Array[Vector2] = [Vector2(-1000000,-1000000)]
var _time : Array[float] = [0.0]
var tangents : Array[Vector2]
var parameters : Vector3 
var inter_timer : float= 0.0
var speed :float= 0.0
var _count = 1

enum STYLE{
	NORMAL,
	LINEAR,
	HCURVE,
	KCURVE,
	SKEW
}
var relative_move = false
var interpolating:bool = false
var move_mode = STYLE.NORMAL

var custom_color = Color.RED
var no_clear = false
var interp_rotation = false
var free_on_contact : bool = true
var ang_spd : float = 0
var offs : bool = true
var angle_offset : float = -PI/2.0

var masked := false :
	set(value):
		masked = value
		z_index = 0 if value else 2
		show_behind_parent = value

func _ready():
	for i in get_children():
		i.add_to_group("bullets")
		for x in i.get_children():
			x.add_to_group("bullets")

func _process(_delta):
	move(_delta)
	set_color()

func set_color():
	if type >= type_color.size() || type < 0:
		modulate = custom_color
	else:
		modulate = type_color[type]

func move(delta):
	match move_mode:
		STYLE.NORMAL:
			if !relative_move:
				global_position += Vector2(xspeed,yspeed)
			else:
				position += Vector2(xspeed,yspeed)
		STYLE.LINEAR:
			inter_timer += delta*float(speed)
			global_position = piecewise_interp(inter_timer,_count,target,_time)
		STYLE.HCURVE:
			inter_timer += delta*float(speed)
			global_position =Hpiecewise_interp(inter_timer,_count,target,_time,tangents)
			if interp_rotation:
				var tx = inter_timer + delta*float(speed)
				var next_pos = Hpiecewise_interp(tx,_count,target,_time,tangents)
				var vec = next_pos-global_position
				rotation = atan2(vec.y,vec.x)+angle_offset
		STYLE.KCURVE:
			inter_timer += delta*float(speed)
			global_position =DDDpiecewise_interp(inter_timer,_count,target,_time,parameters)
			if interp_rotation:
				var tx = inter_timer + delta*float(speed)
				var next_pos = DDDpiecewise_interp(tx,_count,target,_time,parameters)
				var vec = next_pos-global_position
				rotation = atan2(vec.y,vec.x)+angle_offset
	
	
	if offs : delete_offscreen_bullet()

func interpolate(_type:STYLE,_spd:float,_cnt:int,_targ:Array[Vector2],
		_times:Array[float],_tangents:Array[Vector2]=[Vector2.ZERO],
		_params:Vector3=Vector3.ZERO):
	inter_timer = 0.0
	speed = _spd
	_count = _cnt
	target = _targ
	_time = _times
	tangents = _tangents
	parameters = _params
	move_mode = _type
	interpolating = true

func piecewise_interp(t, counts:int,positions:Array[Vector2],times:Array[float]):
	if (t <= times[0]):
		return positions[0]
	elif (t >= times[counts-1]):
		move_mode = STYLE.NORMAL
		interpolating = false
		return positions[counts-1]
		
	
	var cpt : int = 0
	for i in (counts-1):
		if (t <= times[i+1]):
			break
		cpt +=1
	
	var t0:float =times[cpt]
	var t1:float = times[cpt+1]
	
	var u:float = (t-t0)/(t1-t0)
	
	
	return ((1-u)*positions[cpt] + u*positions[cpt+1])

func Hpiecewise_interp(t:float, counts:int,positions:Array[Vector2],times:Array[float],tangent:Array[Vector2]):
	if (t <= times[0]):
		return positions[0]
	elif (t >= times[counts-1]):
		move_mode = STYLE.NORMAL
		interpolating = false
		return positions[counts-1]
		
	
	var cpt : int = 0
	for i in (counts-1):
		if (t <= times[i+1]):
			break
		cpt +=1
	
	var t0:float =times[cpt]
	var t1:float = times[cpt+1]
	var u:float = (t-t0)/(t1-t0)
	
	var fin:Vector2 = (2*pow(u,3)-3*pow(u,2)+1)*positions[cpt]+(-2*pow(u,3)+3*pow(u,2))*positions[cpt+1]+(pow(u,3)-2*pow(u,2)+u)*tangent[cpt]+(pow(u,3)-pow(u,2))*tangent[cpt+1]
	
	return fin

func CRS_piecewise_interp(t:float, counts:int,positions:Array[Vector2],times:Array[float]):
	if (t <= times[0]):
		return positions[0]
	elif (t >= times[counts-1]):
		move_mode = STYLE.NORMAL
		interpolating = false
		return positions[counts-1]
		
	
	var cpt : int = 0
	for i in (counts-1):
		if (t <= times[i+2]):
			break
		cpt +=1
	
	var t0:float =times[cpt]
	var t1:float = times[cpt+1]
	var u:float = (t-t0)/(t1-t0)
	
	
	
	var fin:Vector2 = (1/2.0*pow(u,2)-3/2.0*u+1)*positions[cpt]+(-pow(u,2)+2*u+1)*positions[cpt+1]+(1/2.0*pow(u,2)-1/2.0*u+1)*positions[cpt+2]
	
	return fin

func DDDpiecewise_interp(t:float, counts:int,positions:Array[Vector2],times:Array[float],params:Vector3):
	if (t <= times[0]):
		return positions[0]
	elif (t >= times[counts-1]):
		move_mode = STYLE.NORMAL
		interpolating = false
		return positions[counts-1]
		
	
	var cpt : int = 0
	for i in (counts-1):
		if (t <= times[i+1]):
			break
		cpt +=1
	
	var t0:float =times[cpt]
	var t1:float = times[cpt+1]
	var u:float = (t-t0)/(t1-t0)
	
	var tan1 = ((1-params.x)*(1-params.y)*(1-params.z))/2.0 * (positions[cpt+1]-positions[cpt])+((1-params.x)*(1+params.y)*(1+params.z))/2.0 * (positions[cpt]-positions[cpt-1])
	var tan2 = ((1-params.x)*(1+params.y)*(1-params.z))/2.0 * (positions[cpt+1]-positions[cpt])+((1-params.x)*(1-params.y)*(1+params.z))/2.0 * (positions[cpt]-positions[cpt-1])
	var fin:Vector2 = (2*pow(u,3)-3*pow(u,2)+1)*positions[cpt]+(-2*pow(u,3)+3*pow(u,2))*positions[cpt+1]+(pow(u,3)-2*pow(u,2)+u)*tan1+(pow(u,3)-pow(u,2))*tan2
	
	return fin
	

func delete_offscreen_bullet():
	if position.x > 750 or position.x < -110:
		queue_free()
	if position.y > 600 or position.y < -120:
		queue_free()
