extends Resource
class_name BattleData

@export_group("Battle Modif")
@export var fnf_mode : bool = false
@export var random_status : bool = false
@export var serious_battle : bool = false
@export var Enemies : Array[PackedScene] =[] 
@export var regular_dialogue_style : bool = true
@export_enum("Undertale", "UndertaleXDeltarune") var BattleStyle = "Undertale"
@export var Sound : String
@export var Bullets_patterns : Array[String] = []
@export var battle_script : Script = load("res://Scripts/Battle/BattleContinuity.gd")
@export var H_attacks : Array[String] = []

@export_enum("original","list","hlist") var item_style = "original"
@export var status : Array[String] = []

@export_group("Dialogue Management")
@export var Dialogue_order : Array[Array] = []
@export var dialogue_file : String = ""

@export_subgroup("Player")
@export_multiline var player_dialogue : Array[String] = []

@export_group("Button Style")
@export var button_set : ButtonSet = load("res://Resources/ButtonSet/Default.tres")

@export_group("Others")
@export var random_slice_rotation : bool = false
@export var direct_attack : bool = false
@export var just_a_fight : bool = true
@export var path_to_credit : String
@export var attack_to_continue : bool = false
@export var box_typer : TyperData = load("res://Resources/Typers/Default.tres")
@export var battle_color_theme : Color = Color.WHITE

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
