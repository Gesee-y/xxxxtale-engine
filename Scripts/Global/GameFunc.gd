extends Node

signal ItemUsed(item)

var items_manager : DataManager = DataManager.new()
var target_field = preload("res://Objects/battles/target_field.tscn")
var target_bar = preload("res://Objects/battles/target_bar.tscn")
var items_file : String = "res://Resources/Items/Items.csv"
var armor_file : String = "res://Resources/Items/Armors.csv"
var weapon_file : String = "res://Resources/Items/Weapon.csv"
var current_room = ["Test1",Vector2(320,320)]
var camera_pos : Vector2 = Vector2.ZERO

func CreateTargetBar(_attackers:Array,_targets:Array,box:Box,event_manager:EventsManager):
	var target = target_field.instantiate()
	target.enemy_manager = event_manager.enemies_manager
	box.mask.add_child(target)
	target.position = box.center
	await target.appeared
	var attacker_count = _attackers.size()
	for i in event_manager.enemies_manager.enemies.size():
		if !(i in _targets):
			event_manager.enemies_manager.enemies[i].ReadyForBattle = true
	if attacker_count == 1:
		var player = _attackers[0]
		var BarCount = Global.players[player].weapon.bar_number
		var dir = [-1,1].pick_random()
		var barX = 290 if dir <0 else -290
		for i in BarCount:
			var bar : TargetBar = target_bar.instantiate()
			bar.multibar = BarCount>1
			bar.enemy_manager = event_manager.enemies_manager
			bar.player = player
			bar.target = _targets[0]
			bar.spd = Global.players[player].weapon.bar_speed * dir*2
			bar.position.x = barX - [40,60,80].pick_random() * dir*i
			target.add_child(bar)
	
	return target

func UseItem(item,who:int,to:int,dialogue_manager:DialogueManager,text:Writer,ow:bool=false):
	var StartingHp = Global.players[to].hp
	var _Healed = false
	var itemKeep = false
	var prevArmor = null
	var prevWeapon = null
	var current_hp = 0
	var dialogue = [""]
	var item_to_emit = item
	var idx = Global.Items.find(item)
	if item is ItemData:
		var kr_hp = clamp(Global.players[to].kr_hp + item.healPoint,0,Global.players[to].max_hp)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(Global.players[to],"hp", Global.players[to].hp + item.healPoint,.25).set_trans(Tween.TRANS_SINE)
		Global.players[to].kr_hp += item.healPoint
		Global.players[to].kr_hp = clamp(Global.players[to].kr_hp,0,Global.players[to].max_hp)
		current_hp = Global.players[to].hp + item.healPoint
		
		dialogue = item.use_text
		itemKeep = item.canKeep
	
	if item is ArmorData:
		
		prevArmor = Global.players[to].armor
		Global.players[to].armor = item
		if prevArmor != null:
			Global.Items[idx] = prevArmor
		else:
			Global.Items.erase(item)
		dialogue = item.use_text
	
	if item is WeaponData:
		prevWeapon = Global.players[to].weapon
		Global.players[to].weapon = item
		dialogue = item.use_text
		if prevWeapon != null:
			Global.Items[idx] = prevWeapon
		else:
			Global.Items.erase(item)
	
	if (StartingHp != current_hp and !_Healed) and item is ItemData:
		Global.sound_player.play_sfx("res://Sounds/SFX/heal.ogg")
	var pronoun
	var to_name = ""
	var Name = Global.players[who].Name if who !=0 else "You"
	if !(item is ItemData):dialogue[0] = Name +" " + dialogue[0]
	if (current_hp >= Global.players[to].max_hp) and (item is ItemData):
		dialogue = [""]
		if to!=0:
			pronoun = set_pronoun(to)
		else :
			pronoun = "Your"
		
		if to == who:
			dialogue[0] = Name+" "+item.use_text[0] + "~"+pronoun+" Hp was maxed out. "
		
		else :
			if to == 0:
				to_name = "you"
			else:
				to_name = Global.players[to].Name
			dialogue[0] = Name+" gave the "+ item.long_name + " to "+to_name+"."+ "~"+pronoun+" Hp was maxed out. "
	elif (current_hp < Global.players[to].max_hp) and (item is ItemData):
		dialogue = [""]
		if to!=0:
			pronoun = set_pronoun(to)
		else :
			pronoun = "You"
		if to == who:
			dialogue[0] = Name+" "+item.use_text[0] + "~"+pronoun+" recovered " + str(current_hp - StartingHp) + " HP. "
		else:
			if to == 0:
				to_name = "You"
			else:
				to_name = Global.players[to].Name
			dialogue[0] = Name+" gave the "+ item.long_name + " to "+to_name+"."+"~"+pronoun+" recovered " + str(current_hp - StartingHp) + " HP. "
	if item is ItemData:
		if !itemKeep:
			Global.Items.erase(item)
			if item != null:
				item = null
			_Healed = true
		else:
			Global.Items[(Global.Items.find(item))] = item.new_item
		
	if !itemKeep and not item_to_emit is ItemData:
		Global.sound_player.play_sfx("res://Sounds/SFX/bell.ogg")
	if !ow:
		dialogue_manager.set_dialogue([dialogue],[-1])
		dialogue_manager.Start_dialogue()
		ItemUsed.emit(item_to_emit)
	else:
		text.end_writer()
		text.set_dialogue(dialogue,true,true,false)
		text.next_string()

func set_pronoun(who):
	var pronoun = ""
	if Global.players[who].genre == 0:
		pronoun = "His"
	elif Global.players[who].genre == 1:
		pronoun = "Her"
	elif Global.players[who].genre == 2:
		pronoun = "Their"
	return pronoun

func initialize_item(_item):
	items_manager.file_path = items_file
	var item
	var type = "Heal"
	var item_data = Array(items_manager.get_data_from_csv(_item))
	if item_data == [""] : Array(items_manager.search_through_csv(items_file,_item,1))
	if type == "Heal" and item_data.size() > 2:
		item_data = items_manager.convert_data(item_data)
		item = ItemData.new()
		item.healPoint = item_data[2]
		item.CanDrop=item_data[8]
		item.canKeep=item_data[9]
		if item_data[10] != "":
			item.new_item=initialize_item(item_data[10])
	if item_data.size() <= 2:
		type = "Armor"
		items_manager.file_path = armor_file
		item_data = Array(items_manager.search_through_csv(armor_file,_item))
		if item_data.size() <= 2 : Array(items_manager.search_through_csv(armor_file,_item,1))
		if item_data.size() > 2:
			item_data = items_manager.convert_data(item_data)
			item = ArmorData.new()
			item.defense = item_data[2]
			
	if item_data.size() <= 2:
		type = "Weapon"
	
	if item != null:
		item.normal_name = item_data[0]
		item.serious_name=item_data[1]
		item.long_name=item_data[3]
		item.use_text =item_data[4]
		item.drop_text=item_data[5]
		item.info=item_data[6]
	
	return item

func initialize_armor(_armor):
	var item : Resource
	if _armor != "Bandage":
		items_manager.file_path = armor_file
		var item_data = Array(items_manager.search_through_csv(armor_file,_armor))
		if item_data == [""] : Array(items_manager.search_through_csv(armor_file,_armor,1))
		if item_data != [""]:
			item_data = items_manager.convert_data(item_data)
			item = ArmorData.new()
			item.defense = item_data[2]
			item.normal_name = item_data[0]
			item.serious_name=item_data[1]
			item.long_name=item_data[3]
			item.use_text =item_data[4]
			item.drop_text=item_data[5]
			item.info=item_data[6]
	else:
		item = initialize_item(_armor)
		
	return item

func initialize_weapon(_weapon:String) -> WeaponData:
	var item : WeaponData = WeaponData.new()
	items_manager.file_path = weapon_file
	var item_data = Array(items_manager.search_through_csv(weapon_file,_weapon))
	if item_data == [""] : Array(items_manager.search_through_csv(weapon_file,_weapon,1))
	if item_data != [""]:
		item_data = items_manager.convert_data(item_data)
		item.damage = item_data[2]
		item.normal_name = item_data[0]
		item.serious_name=item_data[1]
		item.long_name=item_data[3]
		item.use_text =item_data[4]
		item.drop_text=item_data[5]
		item.info=item_data[6]
		item.bar_number=item_data[8]
		item.bar_speed = item_data[9]
		item.bar_accel = item_data[10]
		item.animation = load(item_data[11])
		item.sound = item_data[12]
	
	return item

func Encounter():
	pass

func ChangeRoom(room_name:String):
	get_tree().change_scene_to_file(Rooms.Room.get(room_name,null))

func Go_to_Overworld(_just_a_fight:bool=false,_credits:String=""):
	if _just_a_fight:
		get_tree().change_scene_to_file(_credits)
	else:
		get_tree().quit()
