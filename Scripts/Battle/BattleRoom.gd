extends Node2D
class_name BattleManager

signal event

# Some variable for the object who are by default in the BattleRoom
@onready var player : PlayerSoul = $Heart
@onready var view : SubViewport = $ViewContainer/View
@onready var camera : BattleCamera = $Camera
@onready var gradient : Sprite2D = $ViewContainer/View/gradient
@onready var particule : CPUParticles2D = $ViewContainer/View/particule
@onready var back_layer : TextureRect = $ScrollingBackground
@onready var debug : RichTextLabel = $ViewContainer/View/Debug

var box : Box = load("res://Objects/battles/box.tscn").instantiate() # The battle box
var battle_ui : BattleUI = BattleUI.new() # Manage of the UI like the hp bar,LV,player name,etc.
var attack_manager : AttackManager = AttackManager.new() # Manage the attacks and bullets
var enemy_manager : EnemyManager = EnemyManager.new() # Manage the enemies
var button_controller : ButtonController = ButtonController.new() # Manage the buttons(fight,act,items,mercy)
var event_manager : EventsManager = EventsManager.new() # Manage the events(execute the player action)
var continuity : BattleContinuity = BattleContinuity.new() # This manage how the fight will go(if fo example a new enemy should appear at some point it's in it that we add it
var text_manager : Control = Control.new() # Just to contain the writer
var text : Writer = Writer.new() # this class write text
var page_label : RichTextLabel = RichTextLabel.new() # For the item menu
var mask : Polygon2D # mask for the attacks

#-------------- FNF Object --------------#
var stats : FNFStats = FNFStats.new()
var flow_bar : FlowBar = FlowBar.new()

var placeholder = load("res://Sprites/Weapon animation/Stick/spr_strike_0.png")
var place_holder_sprite : Sprite2D = Sprite2D.new() # We will use it to initialize the mask

var item_page : int = 0 # On which set of item we are
var player_events : Array[Array] = [] # keep track of the player decision
var order : Array[String] = ["defend","act","magic","mercy","item","fight"]
var player_active : int = 0 # The current player
var battle_finish : bool = false # if the battle is finish it's true

var menu_no : Array[int] = [-1,0] #We will use it for navigation
var menu_coord : Array[int] = [0,0]
var menu_timer : float = 0

var button_y : float = 450
var button_pos: Array[Vector2]= [
	Vector2(70,button_y),Vector2(194,button_y),
	Vector2(318,button_y),Vector2(442,button_y)
]

# Some variable to keep tracks of things
var text_table : Array[Array]
var cols_pos : Array[float] = [61,320]
var rows_pos : Array[float] = [287,320,350]
var initialized : bool = false
var enemy_hp_bars : Array = []
var y_margin = -15
var last_menu = 0
var count = 0
var battle : BattleData = null

# Called when the node enters the scene tree for the first time.
# Every class declare above will have to be initialize here
func _ready():
	battle = Global.current_fight
	battle_ui.main = self
	add_box()
	view.add_child(battle_ui)
	add_child(text_manager)
	
	text_manager.size = Vector2(640,480)
	text_manager.z_index=1
	text_manager.add_child(text)
	text_manager.modulate = Global.current_fight.battle_color_theme
	text.position = Vector2(45,268)
	text.typer = load("res://Resources/Typers/Default.tres")
	text.asterisk = true
	
	place_holder_sprite.texture = placeholder
	mask.add_child(place_holder_sprite)
	
	add_enemy_manager()
	add_event_manager()
	add_continuity()
	add_attack_manager()
	
	if !battle.fnf_mode : normal_intialization()
	else : fnf_initialization()

func _process(delta):
	debug.visible = Global.debug
	
	if place_holder_sprite != null:
		if count > 0:
			continuity.Intro()
			place_holder_sprite.queue_free()
		count+=1
	battle_ui.current_player = clampi(player_active,0,Global.players.size()-1)
	
	if Global.current_phase == Global.phase.PLAYER:
		battle_menu(delta)
	elif Global.current_phase >= Global.phase.END and Global.current_phase != Global.phase.NULL:
		player.visible = false
		
		if text.dialogue.is_empty():
			var _exp = enemy_manager.total_exp
			var _gold = enemy_manager.total_gold
			button_controller.selected = -1
			text.set_dialogue(["You Won!!~You earned %d EXP and %d Gold."%[_exp,_gold]],true,true,true)
			text.next_string()
		
		if Global.current_phase == Global.phase.END:
			Global.current_phase = Global.phase.X
		
		if Input.is_action_just_pressed("accept") and text.finish_writing() and !battle_finish:
			battle_finish = true
			var tween = Global.display.fade(Color.BLACK,G_Display.TYPE.IN,2)
			tween.finished.connect(GameFunc.Go_to_Overworld)

func battle_menu(_delta:float):
	player.lock = true
	player.cooldown = 0
	player.inv_frames = false
	if Input.is_action_just_pressed("cancel") and box_is_normal():
		if menu_no[0] >-1 and menu_no[1]==0:
			page_label.visible = false
			button_controller.selected = menu_no[0]
			enemy_hp_bars = Array(free_array_of_node(enemy_hp_bars))
			go_to_menu(-1)
	
	match menu_no[0]:
		-1:main_menu(_delta)
		0:attack_menu(_delta)
		1:act_menu(_delta)
		2:if Global.Items.size()>0:items_menu(_delta)
		3:mercy_menu(_delta)

func main_menu(_delta:float):
	if menu_timer <1.0:
		lerp_player_to_pos(button_controller.button_pos[last_menu] + button_controller.button_set.margin,menu_timer)
		player.lock = true
		player.velocity = Vector2.ZERO
		menu_timer+=1/20.0
	if menu_timer > 0.85 and box_is_normal():
		if text.dialogue.is_empty():
			if button_controller.selected == -1 : button_controller.selected = last_menu
			text.set_dialogue([continuity.battle_status(continuity.get_turn())],true,true,true)
			text.next_string()

func submenu_move(dir,_count,_type:String = "Y",_menu : int = 0):
	menu_coord[_menu] = posmod(menu_coord[_menu]+dir,_count)
	if dir != 0: Global.sound_player.play_sfx("res://Sounds/SFX/menu_move.ogg")
	match _type:
		"Y" : player.global_position = text_table[menu_coord[_menu]][0].global_position + Vector2(-10,17)
		"XY" : player.global_position = text_table[int(menu_coord[_menu]>1)][menu_coord[_menu]%2].global_position + Vector2(-10,17)
	

func attack_menu(_delta):
	if !initialized:
		text_table = create_enemy_list()
		for i in enemy_manager.enemies.size():
			if enemy_manager.enemies[i].show_healthbar:
				var bar = create_enemy_health_bar(enemy_manager.enemies[i].current_hp,
						enemy_manager.enemies[i].max_hp,Vector2(cols_pos[1],rows_pos[i]+y_margin/2.0))
				enemy_hp_bars.append(bar)
		initialized = true
	var dir = int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up"))
	submenu_move(dir,enemy_manager.enemies_count)
	if Input.is_action_just_pressed("accept"):
		emit_signal("event","fight",player_active,menu_coord[0])

func act_menu(_delta):
	match menu_no[1]:
		0:
			if !initialized:
				text_table = create_enemy_list()
				initialized = true
			var dir = int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up"))
			submenu_move(dir,enemy_manager.enemies_count)
			if Input.is_action_just_pressed("accept"):
				go_to_menu(1,true)
				
		1:
			var acts : Array = enemy_manager.enemies[menu_coord[0]].act_keys
			if !initialized:
				text_table = create_text_table(2,2,acts)
				initialized = true
			var dir1 = int(Input.is_action_just_pressed("right"))-int(Input.is_action_just_pressed("left"))
			var dir2 = (int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up")))*2
			submenu_move(dir1,acts.size(),"XY",1)
			submenu_move(dir2,acts.size(),"XY",1)
			if Input.is_action_just_pressed("accept"):
				emit_signal("event","act",player_active,enemy_manager.enemies[menu_coord[0]],acts[menu_coord[1]])
				
			if Input.is_action_just_pressed("cancel"):
				go_to_menu(0,true)

func items_menu(_delta):
	var item_name = get_item_page(item_page)
	while item_name.size() == 0 and item_page != 0:
		item_page -= 1
		item_name = get_item_page(item_name)
	
	if !initialized:
		reset_text_table()
		page_label.visible = true
		page_label.text = "Page %d"%[item_page+1]
		text_table = create_text_table(2,2,item_name)
		initialized = true
	var dir1 = int(Input.is_action_just_pressed("right"))-int(Input.is_action_just_pressed("left"))
	var dir2 = (int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up")))*2
	if item_name.size() > 3 and Global.Items.size() > 4*(1+item_page):
		if (dir1 > 0 and menu_coord[0]==3):
			item_page +=1
			initialized = false
	if (dir1 < 0 and menu_coord[0]==0):
		if item_page > 0:
			item_page -= 1
			initialized = false
		
	submenu_move(dir1,item_name.size(),"XY")
	submenu_move(dir2,item_name.size(),"XY")
	if Input.is_action_just_pressed("accept"):
		page_label.visible = false
		emit_signal("event","item",player_active,0,Global.Items[menu_coord[0]+item_page*4])

func mercy_menu(_delta):
	match menu_no[1]:
		0:
			if !initialized:
				text_table = create_enemy_list()
				initialized = true
			var dir = int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up"))
			submenu_move(dir,enemy_manager.enemies_count)
			if Input.is_action_just_pressed("accept"):
				go_to_menu(1,true)
		1:
			var acts : Array = ["Spare","Flee"] if !enemy_manager.enemies[menu_coord[0]].canSpare else ["[color=yellow]Spare","Flee"]
			if !player.can_flee: acts.erase("Flee")
			if !initialized:
				text_table = create_text_table(1,acts.size(),acts)
				initialized = true
			var dir = int(Input.is_action_just_pressed("down"))-int(Input.is_action_just_pressed("up"))
			submenu_move(dir,acts.size(),"Y",1)
			if Input.is_action_just_pressed("accept"):
				emit_signal("event","mercy",player_active,menu_coord[1])
			if Input.is_action_just_pressed("cancel"):
				go_to_menu(0,true)

func go_to_menu(idx:int,_sub:bool = false):
	reset_text_table()
	Global.sound_player.play_sfx("res://Sounds/SFX/menu_select.ogg")
	menu_no[0+int(_sub)] = idx
	if !_sub:
		menu_no[1] = 0
	initialized = false

func reset_text_table():
	for i in text_table.size():
		text_table[i] = Array(free_array_of_node(text_table[i]))
	text_table = []

func get_item_page(_page:int):
	var arr : Array[String] = []
	for i in 4:
		if i+4*_page < Global.Items.size():
			var _name = Global.Items[i+4*_page].normal_name
			if Global.serious:
				_name = Global.Items[i+4*_page].serious_name
			arr.append(_name)
	
	return arr

func free_array_of_node(arr):
	for i in arr:
		if i != null:
			i.queue_free()
	
	return []

func get_enemies_name() -> Array[String]:
	var arr : Array[String] = []
	for i in enemy_manager.get_children():
		if i is Enemy:
			if !i.Spared and !i.killed:
				var _name = i.enemy_name if !i.canSpare else "[color=yellow]"+i.enemy_name
				arr.append(_name)
	
	return arr

func box_is_normal():
	if (box.angle == 0 and box.xpos == 0 and 
			box.ypos ==0 and box.xscale == 0 
			and box.yscale ==0 and box.form == "rect"):
		return true
	
	return false

func normal_intialization():
	button_controller.player = player
	view.add_child(button_controller)
	page_label.size = Vector2(100,40)
	page_label.add_theme_color_override("default_color",text.typer.color)
	page_label.add_theme_font_override("normal_font",text.typer.text_font)
	page_label.add_theme_font_size_override("normal_font_size",text.typer.font_size)
	page_label.position = Vector2(490,340)
	text_manager.add_child(page_label)
	button_controller.menu_selected.connect(_on_menu_selected)
	event.connect(_on_event)

func fnf_initialization():
	view.add_child(stats)
	stats.main = self
	flow_bar.attack_manager = attack_manager
	flow_bar.stats = stats
	view.add_child(flow_bar)
	flow_bar.scored.connect(Callable(stats,"_on_scored"))
	battle_ui.position.y+=30

func add_continuity():
	continuity.set_script(battle.battle_script)
	continuity.text = text
	continuity.main = self
	continuity.box = box
	continuity.attacks = attack_manager
	continuity.enemy = enemy_manager
	continuity.heart = player
	event_manager.add_child(continuity)

func add_attack_manager():
	attack_manager.mask = mask
	attack_manager.main = self
	attack_manager.box = box
	attack_manager.player = player
	attack_manager.pattern = battle.Bullets_patterns
	add_child(attack_manager)

func add_box():
	add_child(box)
	box.self_modulate = Global.current_fight.battle_color_theme
	box.player = player
	mask = box.mask
	mask.modulate = Global.current_fight.battle_color_theme
	player.box = box

func add_event_manager():
	event_manager.main = self
	event_manager.enemies_manager = enemy_manager
	event_manager.text = text
	event_manager.attack_manager = attack_manager
	event_manager.box = box
	add_child(event_manager)

func add_enemy_manager():
	enemy_manager.main = self
	enemy_manager.box = box
	enemy_manager.text = text
	for i in battle.Enemies:
		enemy_manager.enemies.append(i.instantiate())
	enemy_manager.enemies_count = battle.Enemies.size()
	view.add_child(enemy_manager)
	if !battle.fnf_mode: enemy_manager.ready_enemy()

func create_enemy_list():
	var enemy_names : Array[String] = get_enemies_name()
	return create_text_table(1,3,enemy_names)

func create_text_table(_rows = 1,_cols = 1,_value:Array=[""],_add:String = " * "):
	var table : Array[Array] = []
	for i in _cols:
		var col_array : Array[RichTextLabel] = []
		for x in _rows:
			if x+_rows*i < _value.size():
				var lab : RichTextLabel = RichTextLabel.new()
				lab.text = _add+_value[x+_rows*i]
				lab.size = Vector2(270,60)
				lab.bbcode_enabled = true
				lab.add_theme_font_override("normal_font",text.typer.text_font)
				lab.add_theme_font_size_override("normal_font_size",text.typer.font_size)
				text_manager.add_child(lab)
				lab.position = Vector2(cols_pos[x]+10,rows_pos[i]+y_margin)
				col_array.append(lab)
		table.append(col_array)
	return table

func create_enemy_health_bar(value, max_value,_pos):
	var bar = ProgressBar.new()
	bar.show_percentage = false
	bar.size = Vector2(100,20)
	bar.min_value = 0
	bar.position = _pos
	bar.max_value = max_value
	var back = StyleBoxFlat.new()
	back.bg_color = Color(Color.RED,1.0)
	var fill = StyleBoxFlat.new()
	fill.bg_color = Color(Color.LIME,1.0)
	box.add_child(bar)
	enemy_hp_bars.append(bar)
	bar.value =value
	bar.add_theme_stylebox_override("background",back)
	bar.add_theme_stylebox_override("fill",fill)
	
	return bar

func lerp_player_to_pos(_final_pos:Vector2,_time:float):
	player.position = player.position.lerp(_final_pos,_time)

func next_player_turn():
	player_active += 1
	if player_active >= Global.party_num:
		go_to_menu(-2)
		start_events()
	else:
		menu_no = [-1,0]

func start_events():
	player.visible = false
	player_events.sort_custom(sort_event)
	Global.current_phase = Global.phase.PLAYER_EVENTS
	event_manager.events = player_events
	event_manager.event()

func sort_event(a,b):
	var idx_a = order.find(a[0])
	var idx_b = order.find(b[0])
	if idx_a < idx_b:
		return true
	elif idx_a== idx_b:
		if a[1] < b[1]:
			return true
	
	return false

func reset():
	event_manager.reset_event()

func _on_menu_selected(_menu_no:int):
	initialized = false
	menu_no[0] = _menu_no
	last_menu = button_controller.selected
	button_controller.selected = -1
	text.end_writer()

func _on_event(_event:String,_player,_to,_what = null):
	player_events.append([_event,_player,_to,_what])
	next_player_turn()
