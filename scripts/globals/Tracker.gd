extends Node

var bits_spent : int = 0
var bits_collected : int = 0

var tiles_opened : int = 0
var mines_opened : int = 0

var damage_taken : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset() -> void:
	bits_spent = 0
	bits_collected = 0
	tiles_opened = 0
	damage_taken = 0
