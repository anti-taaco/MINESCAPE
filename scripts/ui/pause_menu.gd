extends Control

@onready var texture: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = Global.mouse_outside
	
	
	var window_size = get_viewport().get_visible_rect().size
	#global_position = Vector2(-window_size.x/2, window_size.y/2)
	#$CenterContainer/TextureRect.resize(window_size.x, window_size.y)
