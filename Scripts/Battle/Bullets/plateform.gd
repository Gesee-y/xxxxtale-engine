extends CharacterBody2D
class_name Plateform

signal on_plateform

@onready var sprite = $sprite
@onready var collision = $CollisionShape2D

var xscale :float = 40
var angle : float= 0:
	set(value):
		rotation_degrees = value
		angle = value
var on_it :bool = false
var type :int= 0
var xspeed : float = 2
var yspeed : float = 0
var tex1 = preload("res://Sprites/Bullets/platform.png")
var tex2 = preload("res://Sprites/Bullets/platform2.png")
var masked := false :
	set(value):
		masked = value
		z_index = 0 if value else 2
		show_behind_parent = value

var set_to_center : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_sprite()
	Global.display.fader.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position += Vector2(xspeed,yspeed)
	set_sprite()
	match type:
		0:
			sprite.texture = tex1
			if check_player_is_on_it():
				on_it = true
				emit_signal("on_plateform")
				get_player().global_position += Vector2(xspeed,yspeed)
			else:
				on_it = false
		1:
			sprite.texture = tex2
			if check_player_is_on_it():
				on_it = true
				emit_signal("on_plateform")
			else:
				on_it = false

func check_player_is_on_it():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is PlayerSoul:
			return true
	
	return false

func get_player():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is PlayerSoul:
			return collider
	
	return null

func set_sprite():
	sprite.size.x = xscale
	collision.shape.size.x = xscale
	collision.position.x = xscale/2.0
	if set_to_center: 
		collision.position.x = 0
		sprite.position.x = -xscale/2.0
