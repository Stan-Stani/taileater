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
		

				
				
