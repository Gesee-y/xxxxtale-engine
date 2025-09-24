extends Bullet

@onready var bone = $Bone
@onready var collision = $Bone/Hitbox/CollisionShape2D
@onready var hitbox = $Bone/Hitbox

var offset_top : float = 20
var offset_down : float = 1
var piv_pos : Vector2 = Vector2.ZERO
var angle : float = 0
var set_piv_pos : bool = true
var paps = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if paps: set_paps_bone()
	free_on_contact = false
	

func _process(delta):
	super._process(delta)
	bone.size.y = offset_top+offset_down+13
	bone.position.y = -offset_top
	if set_piv_pos : piv_pos = Vector2(bone.size.x/2.0,(bone.size.y/2.0))
	else: piv_pos = Vector2.ZERO
	bone.pivot_offset = piv_pos
	collision.shape.size.y = bone.size.y-6
	collision.position.y = 6.5+ (bone.size.y-13)/2.0
	angle += ang_spd
	bone.rotation_degrees = angle

func set_paps_bone():
	bone.texture = load("res://Sprites/Bullets/Bones/PapsBone.png")
	bone.patch_margin_bottom = 6
	bone.patch_margin_right = 0
	bone.patch_margin_left = 0
	bone.patch_margin_top = 6
