extends Control

@export var stats : Resource

@onready var texture: TextureRect = $TextureRect
@onready var tooltip: PanelContainer = $TextureRect/Tooltip
@onready var stack: Label = $Stack

var stack_num = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	texture.texture = stats.texture
	tooltip.text = stats.name + "\n---------\n" + stats.description
	stack.text = "x" + str(stack_num)
