extends Resource
class_name CharacterResource

@export var Name : String = "Chara"
@export var max_hp : float = 20
@export var hp :float = 20
@export var kr : bool = false
@export var kr_hp : float = 20
@export var attack : float = 1
@export var defense : float = 1
@export var armor_name : String = "Bandage"
@export var weapon_name : String = "Stick"
var weapon : WeaponData
var armor : Resource
@export var EXP : int = 0
@export var LV : int = 1
var down = false
@export var magic_power : int = 10
@export_color_no_alpha var color_theme = Color.WHITE

@export var hp_bars_color : Dictionary = {
	"background":Color.DARK_RED,
	"foreground":Color.YELLOW,
	"karma":Color.HOT_PINK
}

@export_enum("Male", "Female", "Non-Binary") var genre
@export_enum("Act","Magic") var capacity
@export_enum("Main Character","Follower","Sub Character") var sub_character

@export var BattleUI_resource : SpriteFrames

@export var power : Array[MagicResource] = []

