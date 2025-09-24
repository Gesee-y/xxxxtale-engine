extends BattleContinuity


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.players[0].Name = "Player"
	Global.players[0].hp = 92
	Global.players[0].LV = 19
	Global.players[0].max_hp = 92

func Intro():
	main.player.set_mode(PlayerSoul.MODE.GREEN,"",false,1)
	main.player.lock = false
	main.menu_no = [-3,0]
	main.event_manager.turn = -1
	Global.current_phase = Global.phase.ENEMY_ATTACK
	main.event_manager.set_target()
	attacks.pre_attack()
	attacks.start_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
