extends Node
class_name DialogueManager

signal Dialogue_end

@export var file : String

var enemy_manager : EnemyManager
var event_manager : EventsManager
var main : BattleManager
var advanced_mode : bool = false
var current_index : int = 0
var dialogue_started : bool = false
var dialogue_array : Array = []
var index_array : Array = []

var overall_dialogue = []
var overall_index = []

func _ready():
	for enemy in enemy_manager.enemies:
		enemy.writer.dialogue_finished.connect(Continue_dialogue)
	main.text.dialogue_finished.connect(Continue_dialogue)

func Start_dialogue():
	# We ensure that the dialogue array is not empty
	if !dialogue_array.is_empty():
		# We get the dialogue from it
		var dialogue = dialogue_array.pop_front()
		var talker = index_array.pop_front()
		if talker >= 0:
			var _enemy : Enemy = enemy_manager.enemies[talker]
			_enemy.talk(dialogue)
		else :
			main.text.set_dialogue(dialogue,true)
			main.text.next_string()
		current_index += 1
		if !dialogue_started:dialogue_started = true
	else :
		dialogue_started = false
		emit_signal("Dialogue_end")

func Continue_dialogue():
	if !dialogue_array.is_empty():
		Start_dialogue()
	else : 
		emit_signal("Dialogue_end")
		dialogue_started = false

func append_dialogue(_dialogue:Array,_idx):
	dialogue_array.append(_dialogue)
	index_array.append(_idx)

func set_dialogue(_dialogue:Array,_index:Array):
	dialogue_array = _dialogue
	index_array = _index

func get_speech_arrays(file_path:String):
	var _file = FileAccess.open(file_path,FileAccess.READ)
	var text = []
	var speech = []
	var a_talker_text = []
	var talker = ["",""]
	var enemies_name = []
	var index = []
	var idxs = []
	
	for enemy in enemy_manager.enemies:
		enemies_name.append(enemy.enemy_name)
	enemies_name.append("Player")
	
	while !_file.eof_reached():
		var line = _file.get_csv_line(":")
		if line.size() == 1:
			
			if line[0] == "":
				a_talker_text = []
			else:
				a_talker_text.append(line[0])
			
			if line[0] == "{END}":
				talker = ["",""]
				while speech.has([]):
					speech.erase([])
				index.append(idxs)
				text.append(speech)
				a_talker_text = []
				
				speech = []
		else:
			
			talker[0] = line[0]
			if talker[0] != talker[1]:
				if enemies_name.has(talker[0]):
					var idx = enemies_name.find(talker[0])
					speech.append(a_talker_text)
					
					idxs.append(idx)
					
				talker[1] = talker[0]
			
			a_talker_text.append(line[1])
	
	return [text,index]
