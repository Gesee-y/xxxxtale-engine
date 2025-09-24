extends Polygon2D
class_name Box

signal resize_finished

@export var player : PlayerSoul = null

@onready var bg = $BG
@onready var mask = $Mask

var base_arr = []
var prepared_for_circle = false
var center : Vector2 = Vector2.ZERO
var circle_timer : float = 0.0
var form = "rect"
var xscale : float = 0
var yscale : float = 0
var function = RegFunc.new()
var angle : float = 0 :
	set(value):
		angle = value
		if value >= 360:
			angle -= 360
		if value <= -360:
			angle += 360

var spider_node : Node2D = null
var vis_time : float = 0.0
var reset_timer : float = 0.0
var resize_finish = true
var xpos : float = 0
var ypos : float = 0
var radius : float = 70
var ban = 0.0
var trans : Transform2D
var bound : Array[float] = [0.0,0.0,0.0,0.0]
var step:float = 0.1
var last_going = false
var can_push : String = ""
var push_spd :float = .25

# When changing the form of the battle box
# We use the variable to know of the change should be done
# when we change to box from circle 
# we use these array tho know how the change should be done

var rect_position : Array[Vector2] = [Vector2(),Vector2(),Vector2(),Vector2()]
var bg_rect_position : Array[Vector2] = [Vector2(),Vector2(),Vector2(),Vector2()]
var last_size : int = 12
var transform_spd : float = 1/30.0

# ------------ Box Corner ------------#

var corner_left : Vector2
var corner_bottom : Vector2
var corner_b_left : Vector2
var corner_right : Vector2

# ------------ Necessary information for the spider line --------------#

var line = false
var drawed = false
var line_num = 3
var current_line = 0
var pos
var pp = []

# This function create the base spider line

func spider_line(num,_color,_pos:Vector2,_pp):
	spider_node = Node2D.new()
	mask.add_child(spider_node)
	spider_node.show_behind_parent = true
	spider_node.modulate = _color
	spider_node.name = "Spider"
	for i in num:
		var sline = Line2D.new()
		spider_node.add_child(sline)
		sline.width = 1
		sline.add_point(Vector2(_pos.x,corner_left.y+(100 - yscale - (100/float(line_num))*i)))
		sline.add_point(Vector2(_pos.y,corner_left.y+(100 - yscale - (100/float(line_num))*i)))

# this one update it

func update_spider_line(_pos:Vector2):
	if spider_node != null:
		for i in line_num:
			var sline : Line2D = spider_node.get_child(i)
			sline.set_point_position(0,Vector2(_pos.x,corner_left.y+(100 - yscale - (100/float(line_num))*i)))
			sline.set_point_position(1,Vector2(_pos.y,corner_left.y+(100 - yscale - (100/float(line_num))*i)))

func _ready():
	base_arr = [polygon,bg.polygon]
	center = (polygon[0] + polygon[2])/2.0
	trans = Transform2D(deg_to_rad(angle),center)
	set_points_position()
	resize_finished.connect(func():print("resized"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if line:
		pos = Vector2(corner_left.x + 20,corner_bottom.x - 20)
		update_spider_line(pos)
		if !drawed:
			spider_line(line_num,Color.WEB_PURPLE,pos,pp)
			current_line = roundi(line_num/2.0)
			drawed = true
	for i in line_num:
		pp.append(100 - yscale - (100/float(line_num)*i))
	
	trans = Transform2D(deg_to_rad(angle),center)
	if can_push != "":
		push_box(can_push)
	update_rect_size()
	
	if form == "circle":
		if angle == 0:
			reset_timer = 0.0
			make_circle_box(radius,transform_spd,base_arr[0].duplicate(),base_arr[1].duplicate())
			if resize_finish:
				set_points_position()
		else: 
			form = "being_circle"
	if form == "being_circle":
		if reset_timer >= 1:
			reset_timer = 1
		angle = lerpf(angle,0.0,reset_timer)
		set_points_position()
		reset_timer+=1/30.0
		if angle == 0:
			form = "circle"
			prepare_circle_box()
	elif form == "rect":
		make_rect_box(transform_spd,polygon.duplicate(),bg.polygon.duplicate())
		if resize_finish:
			set_points_position()
		else:
			player.last = player.global_position
	
	boundaries()
	set_primary_boundaries()
	if !player.lock and resize_finish:
		if vis_time < 2:
			player.last = player.global_position
		if vis_time > 2:
			set_bound()
			if out_of_bounds(player.global_position):
				check_out_of_bound()
		vis_time += 1
	else:
		vis_time = 0
	
	set_corners()

func set_form(_shape:String="rect",_spd:float=1/20.0,_side:int = 12) -> void:
	if form != _shape:
		transform_spd = _spd
		form = _shape
		if _shape == "circle":prepare_circle_box(_side)

func get_circle_points(r,point_num : int = 48):
	var pos_arr : PackedVector2Array = []
	var bg_pos_arr : PackedVector2Array = []
	for i in point_num:
		var _angle = TAU /float(point_num) * (i+1)
		var x = center.x + r * cos(_angle)
		var y = center.y + r * sin(_angle)
		var x2 = center.x + (r-5) * cos(_angle)
		var y2 = center.y + (r-5) * sin(_angle)
		pos_arr.insert(0,Vector2(x,y))
		bg_pos_arr.insert(0,Vector2(x2,y2))
		
	prepared_for_circle = true
	return [pos_arr,bg_pos_arr]

func make_circle_box(r : float = 70,spd : float = 1/60.0,pon : PackedVector2Array = polygon,
		bg_pon : PackedVector2Array = bg.polygon):
	
	var pnt = get_circle_points(r,pon.size())
	for i in pnt[0].size():
		if circle_timer <= 1:
			pon[i] = pon[i] + circle_timer*(pnt[0][i] - pon[i])
			bg_pon[i] = bg_pon[i] + circle_timer*(pnt[1][i] - bg_pon[i])
	if circle_timer < 1:
		resize_finish= false
		circle_timer+=spd*2
		set_points(pon,bg_pon)
	else:
		angle = 0
		resize_finish = true
	
	if circle_timer > 1 and circle_timer != 1.001:
		emit_signal("resize_finished")
		resize_finish = true
		circle_timer = 1.001

func update_rect_size():
	center = (Vector2(35+xpos+xscale/2.0,253+ypos+yscale/2.0) + 
			Vector2(603+xpos-xscale/2.0,386+ypos-yscale/2.0))/2.0
	
	rect_position[0] = Vector2(35+xpos+xscale/2.0,253+ypos+yscale/2.0)*trans + center
	rect_position[1] = Vector2(603+xpos-xscale/2.0,253+ypos+yscale/2.0)*trans + center
	rect_position[2] = Vector2(603+xpos-xscale/2.0,386+ypos-yscale/2.0)*trans + center
	rect_position[3] = Vector2(35+xpos+xscale/2.0,386+ypos-yscale/2.0)*trans + center
	
	# BG point
	
	bg_rect_position[0] = Vector2(40+xpos+xscale/2.0,258+ypos+yscale/2.0)*trans + center
	bg_rect_position[1] = Vector2(598+xpos-xscale/2.0,258+ypos+yscale/2.0)*trans + center
	bg_rect_position[2] = Vector2(598+xpos-xscale/2.0,381+ypos-yscale/2.0)*trans + center
	bg_rect_position[3] = Vector2(40+xpos+xscale/2.0,381+ypos-yscale/2.0)*trans + center

func make_rect_box(spd : float = 1/60.0,pon : PackedVector2Array = polygon,
		bg_pon : PackedVector2Array = bg.polygon) -> void:
	
	prepared_for_circle = false
	if form == "circle":
		set_correct_base_array()
	form = "rect"
	if circle_timer >= 0 and circle_timer <= 1:
		for i in base_arr[0].size():
		
			pon[i] = pon[i] + (1.0-circle_timer)*(base_arr[0][i] - pon[i])
			bg_pon[i] = bg_pon[i] + (1.0-circle_timer)*(base_arr[1][i] - bg_pon[i])
	if circle_timer > 0:
		circle_timer-=spd
		set_points(pon,bg_pon)
		resize_finish = false
	elif circle_timer != -0.1 and base_arr[0].size() != 4:
		destroy_pnt(12)
		emit_signal("resize_finished")
		resize_finish = true
		
		set_points(base_arr[0],base_arr[1])
		circle_timer= -0.1
	

func destroy_pnt(side) -> void:
	for i in 4:
		for x in side-1:
			base_arr[0].remove_at(i+1)
			base_arr[1].remove_at(i+1)

func set_points(arr:PackedVector2Array,arr2:PackedVector2Array) -> void:
	polygon = arr
	bg.polygon = arr2
	mask.polygon = bg.polygon

func set_correct_base_array(side=12) -> void:
	var bpos : PackedVector2Array = rect_position
	var bgpos : PackedVector2Array = bg_rect_position
	var arr : Array[Array] = []
	var arr2 : Array[Array]= []
	for i in 4:
		var s = i+1 if i + 1 < 4 else 0
		var a = []
		var a2 = []
		for x in side:
			var _pos = rect_position[i] + (x+1)/float(side) * (rect_position[s] - rect_position[i])
			var _pos2 = bg_rect_position[i] + (x+1)/float(side) * (bg_rect_position[s] - bg_rect_position[i])
			a2.append(_pos2)
			a.append(_pos)
		arr.append(a)
		arr2.append(a2)
	
	for i in arr.size():
		for x in arr[i].size():
			var item = arr[i].pop_back()
			var item2 = arr2[i].pop_back()
			bpos.insert(1+side*i,item)
			bgpos.insert(1+side*i,item2)
	
	for i in 4:
		bpos.remove_at(bpos.size()-1)
		bgpos.remove_at(bgpos.size()-1)
	
	base_arr = [bpos,bgpos]

func prepare_circle_box(side = 12) -> PackedVector2Array:
	last_size = side
	var bpos : PackedVector2Array = polygon.duplicate()
	var bgpos : PackedVector2Array = bg.polygon.duplicate()
	var arr : Array[Array] = []
	var arr2 : Array[Array]= []
	for i in 4:
		var s = i+1 if i + 1 < 4 else 0
		var a = []
		var a2 = []
		for x in side:
			var _pos = polygon[i] + (x+1)/float(side) * (polygon[s] - polygon[i])
			var _pos2 = bgpos[i] + (x+1)/float(side) * (bgpos[s] - bgpos[i])
			a2.append(_pos2)
			a.append(_pos)
		arr.append(a)
		arr2.append(a2)
	
	for i in arr.size():
		for x in arr[i].size():
			var item = arr[i].pop_back()
			var item2 = arr2[i].pop_back()
			bpos.insert(1+side*i,item)
			bgpos.insert(1+side*i,item2)
	
	for i in 4:
		bpos.remove_at(bpos.size()-1)
		bgpos.remove_at(bgpos.size()-1)
	
	base_arr = [bpos,bgpos]
	set_points(bpos,bgpos)
	return bpos
	

func set_corners():
	corner_left = polygon[0]
	corner_right = polygon[1]
	corner_bottom = polygon[2]
	corner_b_left = polygon[3]

func set_points_position():
	if form == "rect" or form == "being_circle":
		set_points(rect_position,bg_rect_position)
	
	if form == "circle":
		center = Vector2(320,320) + Vector2(xpos,ypos)
		var pnt = get_circle_points(radius,polygon.size())
		set_points(pnt[0],pnt[1])

func push_box(_dir:String):
	match _dir:
		"left":
			if abs(player.position.x - bound[1]) < 13:
				xpos -= push_spd
		"right":
			if abs(player.position.x - bound[0]) < 13:
				xpos += push_spd
		"up":
			if abs(player.position.y - bound[3]) < 13:
				ypos -= push_spd
		"down":
			if abs(player.position.y - bound[2]) < 13:
				ypos += push_spd
	#if _dir in ["left","right"]:ypos += sin(xpos)
	#else: xpos += sin(ypos)

#-------Collision Detection---------#

func boundaries() -> void:
	Global.boundaries.up = 253+ypos+yscale/2.0
	Global.boundaries.down = 386+ypos-yscale/2.0
	Global.boundaries.left = 35+xpos+xscale/2.0
	Global.boundaries.right = 603+xpos-xscale/2.0

func set_primary_boundaries() -> void:
	if corner_left.x < corner_bottom.x:
		Global.boundaries.left = corner_left.x
	else :
		Global.boundaries.left = corner_bottom.x
	if corner_left.y < corner_bottom.y:
		Global.boundaries.up = corner_left.y
	else:
		Global.boundaries.up = corner_bottom.y
	if corner_left.x > corner_bottom.x:
		Global.boundaries.right = corner_left.x
	else :
		Global.boundaries.right = corner_bottom.x
	if corner_left.y > corner_bottom.y:
		Global.boundaries.down = corner_left.y
	else :
		Global.boundaries.down = corner_bottom.y

func distance_to_box() -> Array[Array]:
	var tl_tr : Vector2 = corner_right - corner_left
	var tl_bl : Vector2 = corner_b_left - corner_left
	var tr_br : Vector2 = corner_bottom - corner_right
	var bl_br : Vector2 = corner_bottom - corner_b_left
	
	
	var c1 : float = tl_tr.x*corner_right.y - tl_tr.y * corner_right.x
	var c2 : float = tl_bl.x*corner_left.y - tl_bl.y * corner_left.x
	var c3 : float = tr_br.x*corner_bottom.y - tr_br.y * corner_bottom.x
	var c4 : float = bl_br.x*corner_b_left.y - bl_br.y * corner_b_left.x
	
	var distance_array : Array[float] = [
		abs(tl_tr.y * player.global_position.x - tl_tr.x * player.global_position.y + c1) / tl_tr.length(),
		abs(tl_bl.y * player.global_position.x - tl_bl.x * player.global_position.y + c2) / tl_bl.length(),
		abs(bl_br.y * player.global_position.x - bl_br.x * player.global_position.y + c4) / bl_br.length(),
		abs(tr_br.y * player.global_position.x - tr_br.x * player.global_position.y + c3) / tr_br.length()
	]
	
	var vector_array : Array[Vector2] = [tl_tr,tl_bl,bl_br,tr_br]
	var c_array : Array[float] = [c1, c2, c4, c3]
	
	return [distance_array,vector_array,c_array]

func find_projection() -> Array[Vector2]:
	var projection : Array[Vector2] = []
	var vector_array : Array[Vector2] = distance_to_box()[1]
	var c_array : Array[float] = distance_to_box()[2]
	var x_vec :Array[float] = []
	var y_vec :Array[float] = []
	
	for i in vector_array.size():
		var vec = vector_array[i]
		var norm = Vector2(vec.y,-vec.x)
		var gam = -(norm.x*player.global_position.x + norm.y*player.global_position.y + c_array[i])/norm.length_squared()
		
		var x = gam*norm.x + player.global_position.x
		var y = gam*norm.y + player.global_position.y
		
		x_vec.append(x)
		y_vec.append(y)
		projection.append(Vector2(x,y))
	
	return projection

func determine_projection() -> Dictionary:
	var projection : Array[Vector2]= find_projection()
	var up_projection : Vector2 = Vector2(0,Global.boundaries.up)
	var down_projection : Vector2 = Vector2(0,Global.boundaries.down)
	var left_projection : Vector2 = Vector2(Global.boundaries.left,0)
	var right_projection : Vector2 = Vector2(Global.boundaries.right,0)
	for i in 4:
		var _dir = player.global_position.direction_to(projection[i])
		if (_dir.x >= 0 and (_dir.y > sin(-PI/4) and _dir.y <= sin(PI/4))):
			right_projection = projection[i]
		if (_dir.y <= 0 and (_dir.x > sin(-PI/4) and _dir.x <= sin(PI/4))):
			up_projection = projection[i]
		if (_dir.x <= 0 and (_dir.y > sin(-PI/4) and _dir.y <= sin(PI/4))):
			left_projection = projection[i]
		if (_dir.y >= 0 and (_dir.x > sin(-PI/4) and _dir.x <= sin(PI/4))):
			down_projection = projection[i]
	
	var dictio = {
		"up"=up_projection.y,
		"down"=down_projection.y,
		"left"=left_projection.x,
		"right"=right_projection.x
	}
	return(dictio)

func set_bound() -> void:
	
	if form == "rect" or form == "being_circle":
		var _dist_offset = 0.0
		
		var _offset_x = 13
		var _offset_y = 13
		var proj_dict = determine_projection()
		
		bound[0] = proj_dict.right
		bound[1] = proj_dict.left
		bound[2] = proj_dict.down
		bound[3] = proj_dict.up
		if (player.get_real_velocity().x + player.global_position.x > bound[0]) || (player.get_real_velocity().x + player.global_position.x < bound[1]):
			player.velocity.x = 0
		if (player.get_real_velocity().y + player.global_position.y > bound[2]) || (player.get_real_velocity().y + player.global_position.y < bound[3]):
			player.velocity.y = 0
		check_out_of_bound()
		player.global_position.x = clampf(player.global_position.x,bound[1]+_offset_x,bound[0]-_offset_x)
		player.global_position.y = clampf(player.global_position.y,bound[3]+_offset_y,bound[2]-_offset_y)
		player.global_position.x = clampf(player.global_position.x,5,635)
		player.global_position.y = clampf(player.global_position.y,5,475)
		player_slide()
		
		check_out_of_bound()
	if form == "circle":
		if out_of_bounds(player.global_position+player.get_real_velocity()):
			player.velocity =Vector2.ZERO
		if out_of_bounds(player.global_position):
			player.velocity = Vector2.ZERO
			player.global_position = player.global_position.lerp(center,0.07)
		player.global_position.x = clampf(player.global_position.x,5,635)
		player.global_position.y = clampf(player.global_position.y,5,475)

func check_out_of_bound() -> void:
	var t = [0.0,0.0,0.0,0.0]
	
	t[0] = (player.global_position.x - player.last.x)/(bound[0]-player.last.x)
	t[1] = (player.global_position.x - player.last.x)/(bound[1]-player.last.x)
	t[2] = (player.global_position.y - player.last.y)/(bound[2]-player.last.y)
	t[3] = (player.global_position.y - player.last.y)/(bound[3]-player.last.y)
	for i in 4:
		
		if t[i] >= 1 and i < 2:
			var ti = 1.0 - bound[i]/abs(player.last.x)
			ti = clampf(ti,0.0,1.0)
			player.global_position.x = lerpf(player.last.x,bound[i],0.95)
		if t[i] >= 1 and i >= 2:
			var ti = 1.0 - bound[i]/abs(player.last.y)
			ti = clampf(ti,0.0,1.0)
			player.global_position.y = lerpf(player.last.y,bound[i],0.95)
	
	player.last = player.global_position

func out_of_bounds(_position:Vector2) -> bool:
	var off = 10
	if _position.distance_to(center)+off > corner_b_left.distance_to(center):
		return true
	return false

func player_slide():
	var dir = Input.get_vector("left","right","up","down").normalized()
	var _line = function.get_cartesian_coef(dir,player.global_position)
	
	var vec_arr : PackedVector2Array = [corner_right - corner_left,corner_b_left - corner_left,
			corner_bottom - corner_right,corner_bottom - corner_b_left]
	var corner : PackedVector2Array = [corner_right,corner_left,corner_bottom,corner_b_left]
	var _angle : float = 0
	
	for i in vec_arr.size():
		var _line2 = function.get_cartesian_coef(vec_arr[i],corner[i])
		var intersect_pnt = function.get_intersection_point(_line,_line2,Vector2.ZERO)
		if intersect_pnt.distance_to(player.global_position) <3:
			var corner_intersect = intersect_pnt - corner[i]
			var player_intersect = player.global_position - intersect_pnt
			_angle = atan2(corner_intersect.y,corner_intersect.x)+atan2(player_intersect.y,player_intersect.x)
			
			if abs(int(_angle) % 45) < 20:
				player.position += corner_intersect.normalized()
	
	

