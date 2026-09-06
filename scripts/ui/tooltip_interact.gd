extends Control

@onready var tooltip : PanelContainer = $Tooltip
var tool_text : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(on_mouse_entered )
	mouse_exited.connect(on_mouse_exited )
	tool_text = tooltip.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_mouse_entered():
	tooltip.toggle(true)
	
func on_mouse_exited():
	tooltip.toggle(false)
