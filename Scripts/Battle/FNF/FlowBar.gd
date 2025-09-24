extends Node
class_name FlowBar

signal scored(_amount:int)

var note_catcher_inst = preload("res://Objects/battles/FNF/NoteCatcher.tscn")
var enemy_note_catcher : NoteCatcher
var player_note_catcher : NoteCatcher
var attack_manager : AttackManager
var stats : FNFStats

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_note_catcher = note_catcher_inst.instantiate()
	enemy_note_catcher.position = Vector2(320,60)
	enemy_note_catcher.bot = true
	enemy_note_catcher.stats = stats
	add_child(enemy_note_catcher)
	
	attack_manager.new_flow_arrow_player.connect(set_new_arrow)
	attack_manager.new_flow_arrow_bot.connect(Callable(enemy_note_catcher,"create_note"))

func set_new_arrow(_arr:Arrow):
	_arr.hitted.connect(gain_score)
	_arr.hitted.connect(decal_camera.bind(_arr.direction))

func decal_camera(_dir:String):
	var camera : BattleCamera = get_node("/root/BattleRoom/Camera")
	var off = ["X",4]
	match _dir:
		"up":off = ["Y",-off[1]]
		"down":off = ["Y",off[1]]
		"left":off = ["X",-off[1]]
		"right":off = ["X",off[1]]
	create_tween().tween_property(camera,"off"+off[0],off[1],0.25).set_trans(Tween.TRANS_SINE)

func gain_score() -> int:
	var score : int = 250
	stats.confront_value[1]+=1
	stats.confront_value[0]-=1
	emit_signal("scored",score)
	return score
