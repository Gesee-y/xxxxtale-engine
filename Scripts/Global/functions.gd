extends Node
class_name RegFunc

var regex = RegEx.new()
var result: Array[RegExMatch]

func in_interval(value:float,_from:float,_to:float) -> bool:
	if value > _from and value < _to:
		return true
	
	return false

func get_cartesian_coef(_vector:Vector2,_point:Vector2) -> Array[float]:
	var c : float = _vector.x*_point.y - _vector.y * _point.x
	return [-_vector.y,_vector.x,c]

func get_intersection_point(_line1:Array[float],_line2:Array[float],def:Vector2 = Vector2.ZERO) -> Vector2:
	var det : float = _line1[0]*_line2[1] - _line1[1]*_line2[0]
	var detX : float = -_line1[2]*_line2[1]+_line1[1]*_line2[2]
	var detY : float = -_line1[0]*_line2[2]+_line1[2]*_line2[0]
	var point : Vector2 = Vector2.ZERO
	if det!=0:
		point.x = detX/det
		point.y = detY/det
	else:
		if detX == 0 and detY == 0:
			if _line1[1] != 0:
				point = Vector2(def.x,(-_line1[2]-_line1[0]*def.x)/_line1[1])
			else:
				point = Vector2(-_line1[2]/_line1[0],def.y)
		else:
			point = def
	
	return point

func nearest_value(value:float,arr:Array[float]):
	var _nearest : float = INF
	var _nearest_dist : float = INF
	for i in arr:
		if abs(value-i)<_nearest_dist:
			_nearest = i
	
	return _nearest

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
			pos = _str.find(what,idx_array[-1]+1)
		idx_array.append(pos)
	
	return idx_array

func remove_bb_code(_str:String):
	regex.compile("\\[.*?\\]")
	result = regex.search_all(_str)
	var cleaned = _str
	for i in  result.size():
		cleaned = cleaned.replace(result[i].get_string(), "")
	
	return cleaned

func find_position_with_bb(_str:String,bb_str:String,idx : int):
	var c = _str[idx]
	var occur = find_occurence(_str,c)
	var ind = occur.find(idx)
	return find_occurence(bb_str,c)[ind]

func get_string_between_idx(_str:String,_from:int,_to:int):
	var _result : String = ""
	for i in _str.length():
		if i >= _from and i <= _to:
			_result = _result + _str[i]
	
	return _result

func find_child_idx(node,parent):
	for i in parent.get_child_count():
		if node == parent.get_child(i):
			return i
	
	return -1

func get_direction(vector:Vector2):
	var _dir = vector.normalized()
	if (_dir.x >= 0 and (_dir.y > sin(-PI/4) and _dir.y <= sin(PI/4))):
		return "right"
	if (_dir.y <= 0 and (_dir.x > sin(-PI/4) and _dir.x <= sin(PI/4))):
		return "up"
	if (_dir.x <= 0 and (_dir.y > sin(-PI/4) and _dir.y <= sin(PI/4))):
		return "left"
	if (_dir.y >= 0 and (_dir.x > sin(-PI/4) and _dir.x <= sin(PI/4))):
		return "down"
	return "default"
