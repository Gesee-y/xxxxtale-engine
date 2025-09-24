extends Sprite2D

signal finish(damage)
signal hitted(bar)
signal appeared

var enemy_manager : EnemyManager
var time : float
var entered : bool = false
var ended : bool = false
var bar_hitted = 0
var damage : int = 0
var multibar : bool = false
var showed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale.x = 0

func appear(_delta) -> void:
	scale.x = lerpf(scale.x,1,time)
	time += _delta
	if time >= 1:
		entered = true
		emit_signal("appeared")

func disappear(_delta) -> void:
	scale.x = lerpf(scale.x,1,time)
	time -= _delta
	if time <= 0:
		queue_free()

func _process(delta) -> void:
	if remaining_bar() == 0 and !ended:
		var number_of_enemy_ready : int = 0
		for enemy in enemy_manager.enemies:
			
			if enemy.ReadyForBattle:
				number_of_enemy_ready += 1
		if number_of_enemy_ready == enemy_manager.enemies.size():
			kill_enemy()
			emit_signal("finish",bar_hitted)
			ended = true
	
	if ended:
		disappear(delta*5)
	
	if !entered:
		appear(delta*5)
	
	elif !ended:
		if Input.is_action_just_pressed("accept") and get_child_count() > 0:
			var bar = nearest_bar()
			if bar.can_hit:
				emit_signal("hitted",bar)
				bar_hitted += 1

func remaining_bar() -> int:
	var count : int = 0
	for child in get_children():
		if child is TargetBar:
			if !child.dead:
				count+=1
	
	return count

func kill_enemy():
	for enemy in enemy_manager.remaining_enemy():
		if enemy.current_hp <= 0:
			enemy.die()

func nearest_bar():
	var nearest = get_child(0)
	var dist = INF
	for i in get_children():
		if abs(i.position.x) < dist and i.can_hit:
			nearest = i
			dist = i.position.x
	
	return nearest
