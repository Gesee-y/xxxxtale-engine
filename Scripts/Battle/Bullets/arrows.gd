extends Bullet
class_name Arrow

signal hitted

@onready var anim : AnimatedSprite2D= $Sprite
var style = 1
var direction = "left"
var tweened = false
var vec = Vector2.ZERO
var spd = 2

func _ready():
	free_on_contact = true
	match direction :
		"up":vec = Vector2.DOWN
		"down":vec = Vector2.UP
		"left":vec = Vector2.RIGHT
		"right":vec = Vector2.LEFT
	anim.position = -vec*300
	super._ready()

func _process(_delta):
	anim.position += vec*spd
	visible = true
	
	anim.rotation = Vector2.UP.angle_to(vec)
	match style :
		0:
			anim.frame = 0
		1:
			anim.frame = 1
		2:
			anim.frame = 2
			if anim.position.distance_to(Vector2.ZERO) < 140 and !tweened:
				tweened = true
				var tween = create_tween()
				
				tween.set_parallel()
				tween.tween_property(self,"rotation_degrees",180,.2).as_relative().set_trans(Tween.TRANS_SINE)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
