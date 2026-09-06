extends Control

@onready var label_bits: Label = $LabelBits


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_bits.text = str(Global.bits)
