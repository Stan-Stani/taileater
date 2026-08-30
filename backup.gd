extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var first_click_of_this_straight_line = Vector2.INF
var prev_click: Vector2 = Vector2.INF
var next_click: Vector2 = Vector2.INF
var last_direction: String = ""
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if prev_click == Vector2.INF: 
				prev_click = event.position
				print("Anchor set at ", prev_click)
			else:
				next_click = event.position
				print("Second click set at ", prev_click)
				
				var slope = (prev_click.y - next_click.y) / (prev_click.x - next_click.x)
				if abs(slope) > 1:
					print('vertical')
					var new_start_pos = Vector2(prev_click.x, prev_click.y)
					if last_direction == "vertical":
						new_start_pos.x = first_click_of_this_straight_line.x
					else:
						first_click_of_this_straight_line = Vector2(new_start_pos.x, first_click_of_this_straight_line.y)
					
					var color_rect = ColorRect.new()
					var directional_length = next_click.y - prev_click.y
					color_rect.anchor_top = 0
					color_rect.position = new_start_pos
					
					var negative_offset = 0
					if directional_length < 0:
						color_rect.position.y -= abs(directional_length)
					
					color_rect.color = Color.WEB_MAROON
					color_rect.size = Vector2(2, abs(directional_length))
					add_child(color_rect)
					last_direction = "vertical"
				else:
					print('horizontal', next_click.x)
					var new_start_pos = Vector2(prev_click.x, prev_click.y)
					if last_direction == "horizontal":
						new_start_pos.y = first_click_of_this_straight_line.y
					else:
						first_click_of_this_straight_line = Vector2(first_click_of_this_straight_line.x, new_start_pos.y)
						var marker = ColorRect.new()
						marker.color = Color.BLACK
						marker.size = Vector2(4,4)
						marker.position = first_click_of_this_straight_line
						add_child(marker)
						
					var color_rect = ColorRect.new()
					var directional_length = next_click.x - prev_click.x
					color_rect.anchor_top = 0
					color_rect.position = new_start_pos
					
					var negative_offset = 0
					if directional_length < 0:
						color_rect.position.x -= abs(directional_length)
					
					color_rect.color = Color.WEB_GREEN
					color_rect.size = Vector2(abs(directional_length), 2)
					add_child(color_rect)
					last_direction = "horizontal"
				
				if first_click_of_this_straight_line == Vector2.INF:
					first_click_of_this_straight_line = prev_click
				prev_click = next_click
				next_click = Vector2.INF

				
				
