extends Instantier
class_name DataManager

# Class for Data management
# Serve to easily track data and easily reuse them instead of always searching them when needed

var file_path : String = "" # The file to work with

# ------------ Script ------------ #

# We use the get_data_from_csv to get the data corresponding to an enemy with his name

func get_data_from_csv(_name,from:int=0) -> PackedStringArray:
	default_value = PackedStringArray([""])
	if !has_object(_name):
		var dat = search_through_csv(file_path,_name,from)
		if dat != PackedStringArray([""]):add_to_list(_name,dat)
	var val = get_object(_name)
	if val == null:val = PackedStringArray([""])
	return val

# This function return a bunch of data from a csv file

func search_through_csv(_file:String,_data_name:String,_from:int=0) -> PackedStringArray:
	var file = FileAccess.open(_file,FileAccess.READ)
	var data : PackedStringArray = ["",""]
	if file != null:
		while !file.eof_reached() && data[_from] != _data_name:
			data = file.get_csv_line()
			if data.size() > 1:
				if data[_from] == _data_name:
					continue
			if _from >= data.size():
				data = [""]
				break
	
	return data

func convert_data(_data:PackedStringArray):
	var result : Array = []
	var boolean = ["false","true"]
	for i in _data:
		var size = result.size()
		if i.is_valid_float():
			result.append(i.to_float())
		elif i.is_valid_int():
			result.append(i.to_int())
		elif i.contains(";"):
			result.append(convert_to_array(i,";"))
		elif i == "[]":
			result.append([])
		elif i in boolean:
			result.append(bool(boolean.find(i)))
		if size == result.size():result.append(i)
	return result

func convert_to_array(_str,delim=";"):
	var strg = ""
	var arr = []
	for i in _str:
		if i != delim:
			strg = strg + i
		else:
			arr.append(strg)
			strg = ""
	
	return arr

# ---------- End ---------- #
