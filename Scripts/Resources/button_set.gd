extends Resource
class_name ButtonSet

@export var fight_button : SpriteFrames = null
@export var act_button : SpriteFrames = null
@export var item_button : SpriteFrames = null
@export var mercy_button : SpriteFrames = null
@export var margin : Vector2 = Vector2(-37,0)

var buttons : Array[SpriteFrames] = []

func set_buttons():
	buttons.append(fight_button)
	buttons.append(act_button)
	buttons.append(item_button)
	buttons.append(mercy_button)
