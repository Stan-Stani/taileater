extends Node2D

var snake_body_scene = preload("res://scenes/snake_body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var first_click_of_this_straight_line = Vector2.INF
var start_of_this_straight_line = Vector2.INF

var prev_click_pos: Vector2 = Vector2.INF
var this_click_pos: Vector2 = Vector2.INF
var prev_orientation := ""
var this_orientation := ""
# left, right, up, down
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

	var line_segment_rect = ColorRect.new()

	if first_click_of_this_straight_line == Vector2.INF:
		first_click_of_this_straight_line \
		 = this_click_pos
		start_of_this_straight_line = first_click_of_this_straight_line
	
	if prev_click_pos == Vector2.INF:
		prev_click_pos = this_click_pos
		return
	
	slope = calculate_slope(prev_click_pos, this_click_pos)
	
	this_orientation = "vertical" if abs(slope) >= 1 else "horizontal"
	
	if this_orientation != prev_orientation && prev_orientation != "":
		var prev_line_start_pos = first_click_of_this_straight_line
		first_click_of_this_straight_line = prev_click_pos
		
		# snap new line to end of old line
		# todo I don't like overwriting variables like this
		# should give new names instead of still calling it "click"
		# maybe like "snapped_..."
		if this_orientation == "vertical":
			start_of_this_straight_line.y = prev_line_start_pos.y
			start_of_this_straight_line.x = first_click_of_this_straight_line.x
			prev_click_pos.y = prev_line_start_pos.y
			
			
		elif this_orientation == "horizontal":
			start_of_this_straight_line.x = prev_line_start_pos.x
			start_of_this_straight_line.y = first_click_of_this_straight_line.y
			prev_click_pos.x = prev_line_start_pos.x
	
	if this_orientation == "vertical":
		line_segment_rect.color = Color.WEB_MAROON
		line_segment_rect.position = Vector2(start_of_this_straight_line.x, prev_click_pos.y)
		var y_delta = this_click_pos.y - prev_click_pos.y
		line_segment_rect.size = Vector2(2, abs(y_delta))
		this_direction = "down"
		# going in negative y direction (up)
		if y_delta < 0:
			line_segment_rect.position.y += y_delta
			this_direction = "up"
		
		
	elif this_orientation == "horizontal":
		line_segment_rect.color = Color.WEB_GREEN
		line_segment_rect.position = Vector2(prev_click_pos.x, start_of_this_straight_line.y)
		var x_delta = this_click_pos.x - prev_click_pos.x
		line_segment_rect.size = Vector2(abs(x_delta), 2)
		this_direction = "right"
		# going in negative x direction (left)
		if x_delta < 0:
			line_segment_rect.position.x += x_delta
			this_direction = "left"
			
	
	
	add_child(line_segment_rect)
	
	var first_click_of_this_straight_line_rect = ColorRect.new()
	first_click_of_this_straight_line_rect.color = Color.BLUE
	first_click_of_this_straight_line_rect.size = Vector2(2,2)
	first_click_of_this_straight_line_rect.z_index = 100
	first_click_of_this_straight_line_rect.position = start_of_this_straight_line
	add_child(first_click_of_this_straight_line_rect)
	var snake_body: AnimatedSprite2D = snake_body_scene.instantiate()
	
	var tex_size: Vector2 = snake_body.sprite_frames.get_frame_texture(
	  snake_body.animation, snake_body.frame
		).get_size()

	snake_body.position = start_of_this_straight_line
	snake_body.offset = Vector2(tex_size.x / 2, 0)    
	
	add_child(snake_body)
	
	print(start_of_this_straight_line)
	if this_direction == 'up':
		snake_body.rotation = deg_to_rad(-90)
	elif this_direction == 'right':
		pass
	elif this_direction == 'down':
		snake_body.rotation = deg_to_rad(90)
	elif this_direction == 'left':
		snake_body.rotation = deg_to_rad(180)
		
	prev_orientation = this_orientation
	prev_click_pos = this_click_pos

func calculate_slope(pos_1, pos_2):
	return((pos_1.y - pos_2.y) /\
	(pos_1.x - pos_2.x))
