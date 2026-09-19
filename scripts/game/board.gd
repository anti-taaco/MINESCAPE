extends Node2D

@onready var t_flag: TileMapLayer = $TileMapFlag
@onready var t_grid: TileMapLayer = $TileMapLayer
@onready var t_num: TileMapLayer = $TileMapNumbers
@onready var t_open: TileMapLayer = $TileMapOpened

var t_size : Vector2i
var w : int = 10
var h : int = 10
var b : int = 2
var mines : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
