extends Node

func get_number_from_string(_string:String,_from:int=0) -> float:
	var _idx : int = _from
	var number_string : String = ""
	while _idx < _string.length():
		if _string[_idx].is_valid_int() or (_string[_idx]=="." and !"." in number_string):
			number_string = number_string + _string[_idx]
		else:
			break
		_idx += 1
	
	return float(number_string)

func replace_one(strg:String, what:String, ForWhat:String) -> String:
	var idx = strg.find(what)
	for i in len(what):
		strg[idx] = ForWhat
	return strg

func get_str_between(_str:String,_start:String,_end:String,from:int=0) -> String:
	var idx = _str.find(_start,from)+1
	var _exp = _str.find(_end,from)-idx
	return _str.substr(idx,_exp)

func find_occurence(_str:String,what:String) -> Array[int]:
	var idx_array : Array[int] = []
	for i in _str.count(what):
		var pos = _str.find(what,0)
		if idx_array.size() > 0:
			pos = _str.find(what,idx_array[-1])
		idx_array.append(pos)
	
	return idx_array
