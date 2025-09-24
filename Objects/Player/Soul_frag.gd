extends Sprite2D
class_name SoulFragment

var frag_array = [load("res://Sprites/Player/battle/heart_shard_1.png"),
		load("res://Sprites/Player/battle/heart_shard_2.png"),
		load("res://Sprites/Player/battle/heart_shard_3.png"),
		load("res://Sprites/Player/battle/heart_shard_4.png")]

var xspeed : float = 0
var yspeed : float = 0
var fall_spd : float = 0.5
var type : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = frag_array[type]
	xspeed*=60
	yspeed *= 60
	fall_spd *= 60


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += xspeed*delta
	position.y += yspeed*delta
	yspeed += fall_spd*delta
