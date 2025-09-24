extends Polygon2D
class_name NoteCatcher

signal scored(_amount:int,_dist:float)

@onready var bg = $BG
@onready var catch_zone = $CatchZone
@onready var collision = $CatchZone/CollisionShape2D
var stats : FNFStats
var note_inst = preload("res://Objects/battles/FNF/note.tscn")

var radius : float = 20
var flash_timer : float = 1
var bot : bool = false
var confront_power : float = 0.5

var note_input:Dictionary={
	0:"up",
	180:"down",
	90:"right",
	-90:"left"
}

var timer : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape.radius = radius-5
	var cicle_array : PackedVector2Array = []
	var bg_circle_array : PackedVector2Array = []
	for i in 20:
		var angle = (TAU)/20.0*i
		var _pos = to_cartesian_from_polar(radius,angle)
		var _pos2 = to_cartesian_from_polar(radius-5,angle)
		cicle_array.append(_pos)
		bg_circle_array.append(_pos2)
	polygon = cicle_array
	bg.polygon = bg_circle_array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flash_timer > 0:
		flash_timer -= delta*2.0
	bg.color = Color(flash_timer/2.0,flash_timer/2.0,flash_timer/2.0)
	check_note()

func check_note():
	var areas = catch_zone.get_overlapping_areas()
	for area in areas:
		if area.has_meta("Note"):
			var idx = note_input.keys().find(int(area.rotation_degrees))
			if bot:
				if area.position.x < 10:
					stats.confront_value[0]+=confront_power
					stats.confront_value[1]-=confront_power
					area.queue_free()
			elif Input.is_action_just_pressed(note_input.get(note_input.keys()[idx],"down")):
				var score : int = gain_score(area.position.x)
				print(score," || ",area.position.x)
				emit_signal("scored",score,area.position.x)
				area.queue_free()
			if area.is_queued_for_deletion():flash_timer = 1

func gain_score(_dist:float) -> int:
	var score : int = 100
	_dist = absf(_dist)
	if _dist < 8:
		score *= 2.5
	elif _dist < 12:
		score *= 2
	
	return score

func create_note(_dir:String,_spd:float):
	var note = note_inst.instantiate()
	note.position.x = 325
	note.speed = _spd
	note.rotation_degrees = note_input.find_key(_dir)
	add_child(note)
	return note

func to_cartesian_from_polar(_radius:float,_angle:float):
	var x = _radius * cos(_angle)
	var y = _radius * sin(_angle)
	return Vector2(x,y)
