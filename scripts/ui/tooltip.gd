extends PanelContainer

@onready var choice: Choice
@onready var tool_text: RichTextLabel = $RichTextLabel
var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choice = get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tool_text.text = text
	if visible:
		global_position = get_global_mouse_position()

func toggle(on: bool):
	if on:
		show()
	else:
		hide()
