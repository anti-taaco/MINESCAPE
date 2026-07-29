extends Node2D

var player : Node2D
var cursor : Node2D
var wikiware
var wiki_screen
var screen_size : Vector2 = Vector2(192, 108)
@onready var button: Polygon2D = $Polygon2D
var button_size = 16

var clicks : int = 0
var required_clicks : int = 5
var cursor_inside = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	wikiware = get_parent().get_parent()
	wiki_screen = Global.find_node_in_parent(wikiware, "Screen")
	#var points = wiki_screen.polygon
	
	teleport_button(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cursor_inside and Input.is_action_just_pressed("M1"):
		clicks += 1
		cursor_inside = false
		teleport_button(button)
	
	if clicks >= required_clicks:
		wikiware.completed = true
		queue_free()

func teleport_button(node):
	var size = screen_size - Vector2(button_size, button_size)
	var x_point = randf_range(-0, size.x)
	var y_point = randf_range(-0, size.y)
	button.global_position = global_position + Vector2(x_point, y_point)

func _on_area_2d_mouse_entered() -> void:
	cursor_inside = true

func _on_area_2d_mouse_exited() -> void:
	cursor_inside = false
