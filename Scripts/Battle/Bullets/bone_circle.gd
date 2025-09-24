extends Bullet

@onready var bones = $Bones

var bone_inst = preload("res://Objects/Bullets/bone.tscn")
var bone_count : int = 5
var radius : float = 20
var bone_size : float = 100

var angle : float = 0
var create_mode : int = 0
var ss : bool = true

func _ready():
	match create_mode:
		0: normal_create()
		1: poly_create()

func normal_create():
	for i in bone_count:
		var _angle = i * (TAU / float(bone_count))
		var bone = bone_inst.instantiate()
		bone.offset_down = bone_size
		bone.offset_top = 0
		bone.offs = false
		bone.position = to_cartesian_from_polar(radius,_angle)
		bone.position.y -= (bone_size+13)/2.0
		bone.type = type
		bone.angle = rad_to_deg(_angle)+90
		bones.add_child(bone)

func poly_create():
	for i in bone_count:
		var _angle = i * (TAU / float(bone_count))
		var bone = bone_inst.instantiate()
		var si = bone_count*radius-5
		bone.offset_down = si
		bone.offset_top = 0
		bone.offs = false
		bone.position = to_cartesian_from_polar(radius,_angle)
		bone.position.y -= si/2.0
		bone.type = type
		bone.angle = rad_to_deg(_angle)
		bones.add_child(bone)

func _process(_delta):
	angle += ang_spd
	rotation_degrees = angle
	move(_delta)
	if ss : set_size()

func set_size():
	match create_mode:
		0:
			for i in bones.get_child_count():
				var _angle = i * (TAU / float(bone_count))
				var bone = bones.get_child(i)
				bone.offset_down = bone_size
				bone.offset_top = 0
				bone.position = to_cartesian_from_polar(radius,_angle)
				var off = bone.bone.pivot_offset*2/7.0
				bone.position.x += off.x
				bone.position.y -= bone_size/2.0+5
				bone.type = type
		1:
			for i in bones.get_child_count():
				var _angle = i * (TAU / float(bone_count))
				var bone = bones.get_child(i)
				var si = bone_count*radius-5
				bone.offset_down = si
				bone.offset_top = 0
				bone.position = to_cartesian_from_polar(radius,_angle)
				var off = bone.bone.pivot_offset*2/7.0
				bone.position.x += off.x
				bone.position.y -= si/2.0+5
				bone.type = type

func to_cartesian_from_polar(_radius:float,_angle:float):
	var x = _radius * cos(_angle)
	var y = _radius * sin(_angle)
	return Vector2(x,y)
