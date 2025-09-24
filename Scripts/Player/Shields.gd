extends Node2D

@onready var shield_blue = $ShieldBlue
@onready var shield_red = $ShieldRed

var arrow_inst = preload("res://Objects/Bullets/arrow.tscn")
var timer : Array[float]= [0.0,0.0]
var blue_inputs : Dictionary = {
	"up":0,
	"down":180,
	"right":90,
	"left":270
}
var red_inputs : Dictionary = {
	"w":0,
	"s":180,
	"d":90,
	"a":270
}

var two_shield : bool = true
var move_spd : float = 1/10.0
var time : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_shield(_shield:AnimatedSprite2D):
	var ang = _shield.get_meta("angle")
	_shield.visible = true
	var shield_idx = get_children().find(_shield)
	if _shield.rotation_degrees != ang:
		ang = deg_to_rad(ang)
		_shield.rotation = lerp_angle(_shield.rotation,ang,timer[shield_idx])
		timer[shield_idx] = clampf(timer[shield_idx]+move_spd,0.0,1.0)
	else:
		timer[shield_idx]=0.0

func shortest_angle(_from:float,_to:float) -> float:
	if absf(-_to+360+_from) < (_to-_from):
		return _to-360
	
	return _to

func get_inputs():
	for input in blue_inputs.keys():
		if Input.is_action_just_pressed(input):
			timer[0]=0.0
			shield_blue.set_meta("angle",blue_inputs[input])
	for input in red_inputs.keys():
		if Input.is_action_just_pressed(input):
			timer[1]=0.0
			shield_red.set_meta("angle",red_inputs[input])

func update_shield():
	set_collision(false,two_shield)
	get_inputs()
	set_shield(shield_blue)
	if two_shield : set_shield(shield_red)
	else : shield_red.visible = false
	set_hit()

func set_collision(_value:bool,_all:bool = false):
	var blue_hitbox = $ShieldBlue/HitBox
	var red_hitbox = $ShieldRed/HitBox
	for child in blue_hitbox.get_children():
		child.disabled = _value
	if _all:
		for child in red_hitbox.get_children():
			child.disabled = _value

func set_hit():
	for i in get_child_count():
		var area : Area2D = get_child(i).get_child(0)
		var areas = area.get_overlapping_areas()
		for zone in areas:
			if zone is Hitbox:
				var bullet = zone.bullet
				if zone.hit_shield:
					if bullet is Arrow:
						if bullet.style==i or bullet.style==2:
							bullet.emit_signal("hitted")
							bullet.queue_free()
					else:
						bullet.queue_free()
				if bullet.is_queued_for_deletion() :Global.sound_player.play_sfx("res://Sounds/SFX/bell.ogg")
