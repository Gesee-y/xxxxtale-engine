extends Resource
class_name WeaponData

@export var damage : int
@export var normal_name : String
@export var long_name : String
@export var serious_name : String
@export var bar_number : int= 1
@export var bar_speed : int = 5
@export_range(0.0,.1) var bar_accel : float = 0
@export var CanDrop : bool
@export var animation : SpriteFrames
@export var sound : String
@export var use_text : Array
@export var drop_text : Array
@export var info : Array

