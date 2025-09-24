extends Node
class_name Cutscene

var player : OWPlayer = null
var text_box : OWBox = null
var camera : BattleCamera = null

func start_scene():
	pass

func end_cutscene():
	player.lock = false
	queue_free()
