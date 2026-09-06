extends PanelContainer

@onready var choice: Choice
@onready var tool_text: RichTextLabel = $RichTextLabel
var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#choice = get_parent().get_parent()
	pass

func initialize(t_size, r_size : Vector2) -> void:
	change_font_size(t_size)
	change_rect_size(r_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tool_text.text = text
	if visible:
		global_position = get_global_mouse_position()

func change_font_size(size):
	tool_text.add_theme_font_size_override("normal_font_size", size)

func change_rect_size(r_size : Vector2):
	size = r_size
	
func toggle(on: bool):
	if on:
		show()
	else:
		hide()
