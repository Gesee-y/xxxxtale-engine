extends Bullet

@onready var sprite = $Sprite
@onready var hitbox = $Sprite/Hitbox
@onready var collision = $Sprite/Hitbox/CollisionPolygon2D

var angle : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	free_on_contact = false
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
