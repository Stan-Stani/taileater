extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var anchor_click: Vector2 = Vector2.INF
var second_click: Vector2 = Vector2.INF
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if anchor_click == Vector2.INF: 
				anchor_click = event.position
				print("Anchor set at ", anchor_click)
			else:
				second_click = event.position
				print("Second click set at ", anchor_click)
				
				var slope = (anchor_click.y - second_click.y) / (anchor_click.x - second_click.x)
				if abs(slope) > 1:
					print('vertical')
				else:
					print('horizontal')
				
				print("slope", slope)
				anchor_click = Vector2.INF
				second_click = Vector2.INF

				
				
