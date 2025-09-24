extends Resource
class_name MagicResource

@export var Name : String
@export var value : int
@export_enum("Offense","Heal") var type : String
@export var tp_cost : int = 20

@export var info_text : Array[String] = []
@export var use_text : Array[String] = []
@export var animation : SpriteFrames
@export var script_path : Script
@export var sound_path : String
@export var hit_impact : int = 15

