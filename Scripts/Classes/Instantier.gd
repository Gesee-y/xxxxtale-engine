extends Node
class_name Instantier

# Class for keeping resource for reuse
# And avoid recreating them everytimes they are needed

var list : Dictionary # This dictionary keep all the already use resource for reuse
var default_value = null # The value to return when the resource doesn't exist 

# This function verify if the list has the object passed in argument
func has_object(path:String) -> bool:
	if list.has(path):
		return true
	return false

# this function add an element to the list
func add_to_list(path:String,value:Variant) -> void:
	var _obj = value
	if _obj != default_value : list[path] = value

# This function return and element from the list return default value if it can't be get
func get_object(path,def_val = null) -> Variant:
	if has_object(path):
		return list[path]
	
	add_to_list(path,def_val)
	return list.get(path,default_value)
