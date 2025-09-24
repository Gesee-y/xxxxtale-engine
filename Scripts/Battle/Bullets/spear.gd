extends Bullet

@onready var sprite = $sprite
@onready var hitbox = $sprite/Hitbox
@onready var collision = $sprite/Hitbox/CollisionShape2D

var angle : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	angle_offset = PI
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
