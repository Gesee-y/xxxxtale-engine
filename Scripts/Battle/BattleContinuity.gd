extends Node
class_name BattleContinuity

var text : Writer
var main : BattleManager
var box : Box
var attacks : AttackManager
var camera : BattleCamera
var heart : PlayerSoul
var enemy : EnemyManager
var turn : int = 0
var timer : float = 0
var gradient_size : float = 1.5
var gradient_speed : float = 2

func _ready():
	Global.players = [load("res://Resources/Characters/Them.tres")]

func Intro():
	Global.sound_player.play_bgm(main.battle.Sound)
	Global.display.fade(Color.BLACK,G_Display.TYPE.OUT,1)

func battle_status(_turn) -> String:
	return "{default:none}You are [shake]going[/shake] to have the [color=lime]worst time[/color]."

func Outro():
	pass

func before_attack():
	pass

func after_attack(_type):
	pass

func after_h_attack():
	pass

func get_turn() -> int:
	return turn

func _process(delta):
	if main.gradient.visible:
		main.gradient.scale.y = (gradient_size+0.4) + sin(timer)*gradient_size
	timer += delta*gradient_speed
