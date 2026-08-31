extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var first_click_of_this_straight_line = Vector2.INF
var prev_click_pos: Vector2 = Vector2.INF
var this_click_pos: Vector2 = Vector2.INF
var prev_direction := ""
var this_direction := ""
var slope := INF

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		handle_click(event)

func handle_click(event):
	this_click_pos = event.position.round()
	var this_click_rect = ColorRect.new()
	this_click_rect.size = Vector2(2,2)
	this_click_rect.position = this_click_pos
	this_click_rect.color = Color.BLACK
	add_child(this_click_rect)
	this_click_rect.z_index = 99
	print('hey')

	var line_segment_rect = ColorRect.new()

	if first_click_of_this_straight_line == Vector2.INF:
		first_click_of_this_straight_line \
		 = this_click_pos
	
	if prev_click_pos == Vector2.INF:
		prev_click_pos = this_click_pos
		return
	
	slope = calculate_slope(prev_click_pos, this_click_pos)
	
	this_direction = "vertical" if abs(slope) >= 1 else "horizontal"
	
	if this_direction != prev_direction && prev_direction != "":
		var prev_line_start_pos = first_click_of_this_straight_line
		first_click_of_this_straight_line = prev_click_pos
		
		# snap new line to end of old line
		# todo I don't like overwriting variables like this
		# should give new names instead of still calling it "click"
		# maybe like "snapped_..."
		if this_direction == "vertical":
			first_click_of_this_straight_line.y = prev_line_start_pos.y
			prev_click_pos.y = prev_line_start_pos.y
			
		elif this_direction == "horizontal":
			first_click_of_this_straight_line.x = prev_line_start_pos.x
			prev_click_pos.x = prev_line_start_pos.x
	
	if this_direction == "vertical":
		print('vertical')
		line_segment_rect.color = Color.WEB_MAROON
		line_segment_rect.position = Vector2(first_click_of_this_straight_line.x, prev_click_pos.y)
		var y_delta = this_click_pos.y - prev_click_pos.y
		line_segment_rect.size = Vector2(2, abs(y_delta))
		if y_delta < 0:
			line_segment_rect.position.y += y_delta
		
		
	elif this_direction == "horizontal":
		print('horizontal')
		line_segment_rect.color = Color.WEB_GREEN
		line_segment_rect.position = Vector2(prev_click_pos.x, first_click_of_this_straight_line.y)
		var x_delta = this_click_pos.x - prev_click_pos.x
		line_segment_rect.size = Vector2(abs(x_delta), 2)
		if x_delta < 0:
			line_segment_rect.position.x += x_delta
			
	
	
	add_child(line_segment_rect)
	
	var first_click_of_this_straight_line_rect = ColorRect.new()
	first_click_of_this_straight_line_rect.color = Color.BLUE
	first_click_of_this_straight_line_rect.size = Vector2(2,2)
	first_click_of_this_straight_line_rect.z_index = 100
	first_click_of_this_straight_line_rect.position = first_click_of_this_straight_line
	add_child(first_click_of_this_straight_line_rect)

	prev_direction = this_direction
	prev_click_pos = this_click_pos

func calculate_slope(pos_1, pos_2):
	return((pos_1.y - pos_2.y) /\
	(pos_1.x - pos_2.x))
