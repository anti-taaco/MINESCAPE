extends Camera2D

@onready var t_grid: TileMapLayer = $"../Board/TileMapLayer"
@onready var v_borders: StaticBody2D = $"V Borders"
@onready var h_borders: StaticBody2D = $"H Borders"

@onready var left: CollisionShape2D = $"V Borders/left"
@onready var right: CollisionShape2D = $"V Borders/right"
@onready var bottom: CollisionShape2D = $"H Borders/bottom"
@onready var top: CollisionShape2D = $"H Borders/top"

var screen = get_viewport_rect()
var border_dist
var zoom_factor : float = 1.25

var window_size
var left_edge
var right_edge
var top_edge
var bottom_edge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var border_dist = Vector2(-242, -137)
	zoom = Vector2(zoom_factor, zoom_factor)
	reposition_borders()
	#for shape : CollisionShape2D in v_borders.get_children():
		#shape.shape.distance = border_dist.x / zoom_factor
	#
	#for shape : CollisionShape2D in h_borders.get_children():
		#shape.shape.distance = border_dist.y / zoom_factor
	
	global_position = Global.board_pos * Vector2(16,16)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not position_smoothing_enabled:
		position_smoothing_enabled = true
		position_smoothing_speed = 16
	reposition_borders()

func reposition_borders():
	window_size = get_viewport().get_visible_rect().size
	left_edge = -window_size.x/2 / zoom_factor
	right_edge = window_size.x/2 / zoom_factor
	top_edge = -window_size.y/2 / zoom_factor
	bottom_edge = window_size.y /2 / zoom_factor
	
	top.global_position = global_position + Vector2(0, top_edge)
	left.global_position = global_position + Vector2(left_edge, 0)
	bottom.global_position = global_position + Vector2(0, bottom_edge)
	right.global_position = global_position + Vector2(right_edge, 0)
