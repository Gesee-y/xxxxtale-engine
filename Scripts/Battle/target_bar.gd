extends AnimatedSprite2D
class_name TargetBar

signal damage(_amount)

var enemy_manager : EnemyManager
var target : int = 0
var player : int = 0
var spd : float = 3
var limits : Array[float] = [-300,300]
var can_hit = true
var multibar : bool = false
var dead = false

func _ready() -> void:
	get_parent().hitted.connect(_on_hitted)
	play("idle")

func _process(_delta) -> void:
	position.x+=spd
	can_hit = in_interval() if !dead else false
	if off_limits() and !dead:
		kill()

func off_limits() -> bool:
	if !multibar or Global.players.size()>1:
		if (position.x < limits[0] and spd < 0) or (position.x > limits[1] and spd > 0):
			return true
	elif multibar:
		if (position.x < -20 and spd < 0) or (position.x > 20 and spd > 0):
			return true
	
	return false

func kill() -> void:
	dead = true
	can_hit = false
	var tween
	if multibar :tween = fade_bar()
	if get_parent().remaining_bar()==0:
		calculate_damage(player,target)
		if Global.players.size() <2 and get_parent().bar_hitted > 0:
			await attack_enemy(target,Global.players[player].weapon)
		elif get_parent().bar_hitted == 0:
			if multibar: await tween.finished
			for enemy in enemy_manager.enemies:
				enemy.ReadyForBattle = true
	if !multibar:
		queue_free()
	else:
		
		tween.finished.connect(queue_free)

func attack_enemy(_idx,_weapon:WeaponData):
	var enemy : Enemy = enemy_manager.enemies[_idx]
	var _animation : AnimatedSprite2D = AnimatedSprite2D.new()
	_animation.sprite_frames =_weapon.animation
	_animation.position = Vector2(enemy.global_position.x,
			enemy.global_position.y - 10)
	if enemy_manager.main.battle.random_slice_rotation : _animation.rotation_degrees = randi_range(-180,180)
	
	get_parent().get_parent().add_child(_animation)
	_animation.z_index =2
	_animation.play("default")
	_animation.animation_finished.connect(Callable(_animation,"queue_free"))
	Global.sound_player.play_sfx(_weapon.sound)
	match enemy.mode: 
		"hit":
			await _animation.animation_finished
			await enemy.show_damage(get_parent().damage,enemy.xpos)
			enemy.ReadyForBattle = true
		"miss":
			enemy.enemy_dodge(_animation)
	fade_bar()

func _on_hitted(who):
	if who == self:
		dead = true
		can_hit = false
		spd = 0
		var fading = false
		calculate_damage(player,target)
		if Global.players.size() <2 and get_parent().remaining_bar()==0:
			fading = true
			if multibar : 
				fading = true
				fade_bar() 
			else : play("hitted")
			await attack_enemy(target,Global.players[player].weapon)
		if multibar and !fading: 
			var twe = fade_bar()
			twe.finished.connect(queue_free)
		

func calculate_damage(_player,_target):
	var enemy = enemy_manager.enemies[_target]
	get_parent().damage += ((Global.players[_player].attack * Global.players[_player].weapon.damage) - enemy.Def) + randi_range(0,10)
	var BarDistance = abs(position.x)
	if BarDistance <= 15:
		get_parent().damage *= 1.4
		if Global.players[player].weapon.bar_number > 1:
			Global.sound_player.play_sfx("res://Sounds/SFX/MultiBar_Perfect.wav")
	else :
		get_parent().damage *= 1 - (BarDistance / 190)
		if Global.players[player].weapon.bar_number > 1:
			Global.sound_player.play_sfx("res://Sounds/SFX/MultiBar_NotPerfect.wav")
	
	get_parent().damage -= enemy.Def
	get_parent().damage = round(get_parent().damage)
	
	if get_parent().damage < 1:
		get_parent().damage = 1
	
	if (Global.players[_player].attack * Global.players[_player].weapon.damage) <= (enemy.Def / 2.0):
		get_parent().damage = 0

func in_interval():
	if position.x > limits[0]+20 and position.x < limits[1]-20:
		return true
	
	return false

func fade_bar():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self,"modulate:a",0,.5)
	tween.tween_property(self,"scale",Vector2(1.5,1.5),.5)
	return tween
