extends Node2D
class_name EnemyManager

signal Acting(who,command:String)

var enemies_count : int = 0
var enemies : Array[Enemy] = []
var total_exp = 0
var total_gold = 0
var box : Box = null
var text : Writer
var main : BattleManager
var id = [0,1,2,3,4,5,6,7,8,9]

func ready_enemy() -> void:
	for i in enemies.size():
		enemies[i].main = main
		add_child(enemies[i])
		enemies[i].connect("dead",_on_enemy_death)
		enemies[i].connect("spared",_on_enemy_spared)
		id.shuffle()
		enemies[i].id = id.pop_front()
	set_enemy_position()
	for i in enemies:
		i.text = text
		Acting.connect(Callable(i,"acting"))

func set_enemy_position() -> void:
	for i in enemies.size():
		enemies[i].xpos = (640/float(enemies_count+1))*(1+i)
		enemies[i].ypos = 150 + box.yscale

func spare_enemy() -> void:
	while can_still_spare():
		for enemy in enemies:
			if enemy.canSpare and !enemy.Spared:
				enemy.spare()

func remaining_enemy() -> Array:
	var enem = []
	for i in enemies:
		if !i.Spared and !i.killed:
			enem.append(i)
	
	return enem

func can_still_spare() -> bool:
	for enemy in enemies:
		if enemy.canSpare and !enemy.Spared:
			return true
	
	return false

func _on_enemy_spared(_enemy:Enemy) -> void:
	enemies.erase(_enemy)
	enemies_count = remaining_enemy().size()
	push_enemy_back(_enemy)
	_enemy.modulate.a = .5
	if !_enemy.collected[1]:
		total_gold += _enemy.Gold
		_enemy.collected[1] = true
	Global.sound_player.play_sfx("res://Sounds/SFX/Vaporise.wav")
	if enemies_count == 0:
		main.event_manager.finish_battle()

func _on_enemy_death(_enemy:Enemy) -> void:
	enemies.erase(_enemy)
	enemies_count = remaining_enemy().size()
	var fade = func():
		await get_tree().create_timer(1).timeout
		_enemy.fade()
	fade.call()
	push_enemy_back(_enemy)
	if !_enemy.collected[0]:
		total_exp += _enemy.Exp
		_enemy.collected[0] = true
	if !_enemy.collected[1]:
		_enemy.collected[1] = true
		total_gold += _enemy.Gold
	if enemies_count==0:
		Global.current_phase = Global.phase.END
		main.event_manager.finish_battle()

func push_enemy_back(_enemy) -> void:
	enemies.push_back(_enemy)
