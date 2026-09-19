extends TileMapLayer

@onready var camera: Camera2D = $"../Camera2D"

@onready var t_flag: TileMapLayer = $"../TileMapFlag"
@onready var t_num: TileMapLayer = $"../TileMapNumbers"
@onready var t_open: TileMapLayer = $"../TileMapOpened"

var t_size : Vector2i
var w : int = 10
var h : int = 10
var b : int = 2
var mines : int = 10

var width : int
var height : int
var center_point = get_viewport_rect().get_center()
var cam_x : int
var cam_y : int

var grid_size : Vector2i
var grid_pos : Vector2i
var top_left : Vector2i
var bottom_right : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	w = Global.width
	h = Global.height
	b = Global.border
	mines = round(Global.mines * Modifiers.mine_multiplier)
	
	var size = Vector2(get_viewport().size.y/(w+b), get_viewport().size.y/(h+b) )
	#tile_set.tile_size = size
	t_size = tile_set.tile_size
	print("Tile size: " + str(t_size))
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y - t_size.y * b
	
	create_grid()
	
	grid_size = get_used_rect().size
	grid_pos = get_used_rect().position #+ Vector2i(100, 100)
	top_left = Vector2i(grid_pos.x, grid_pos.y)
	bottom_right = Vector2i(top_left.x + w-1, top_left.y + h-1)
	Global.board_pos.x = (1 + bottom_right.x + top_left.x ) / 2.0
	Global.board_pos.y = (1 + bottom_right.y + top_left.y) / 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_grid():
	var atlas_coords = Vector2i(0,0)
	var d = w/2
	for i in range(0-d, w-d):
		for j in range(0-d, h-d):
			set_cell(Vector2(i, j), 0, atlas_coords)

func reveal_space(space):
	if get_cell_source_id(space) == 0:
		set_cell(space, -1, get_cell_atlas_coords(space), 0)
		if t_num.get_cell_source_id(space) == 0:
			reveal_adjacent_spaces(space)

func reveal_adjacent_spaces(space):
	for r in range(-1, 2):
		for c in range(-1, 2):
			var cRow = space.x + r
			var cCol = space.y + c
			var checkSpace = true
			if cRow < top_left.x or cRow > bottom_right.x:
				checkSpace = false
			if cCol < top_left.y or cCol > bottom_right.y:
				checkSpace = false
			if checkSpace:
				if t_num.check_adjacent(cRow, cCol) <= 8 or t_num.check_adjacent(cRow, cCol) == 10:
					reveal_space(Vector2(cRow, cCol))
					
func clear_grid():
	for i in range(top_left.x, bottom_right.x+1):
			for j in range(top_left.y, bottom_right.y+1):
				set_cell(Vector2(i, j), -1, Vector2(0,0))

#func _draw():
	#var width = get_viewport_rect().size.x
	#var height = get_viewport_rect().size.y - t_size.y * b
	#var cam_x = camera.global_position.x
	#var cam_y = camera.global_position.y
	#
	#var merged_rect = Rect2(-height/2, cam_y, t_size.x, t_size.y)
	#for i in range(0, w):
		#for j in range(0, h):
			#var rect = Rect2(-cam_x-height/2 + i*t_size.x, -cam_y-height/2 + j*t_size.y, t_size.x, t_size.y)
			#var color
			#if (i % 2 == j % 2):
				#color = Color(1, 0, 0)
			#else:
				#color = Color(0, 0, 1)
			#draw_rect(rect, color)
			#merged_rect = merged_rect.merge(rect)
	#
	#var point = -height/2
	#var point2 = -height/2
	#merged_rect.position = Vector2(point, point2)
	#draw_rect(merged_rect, Color(0,1,0))
	#print(merged_rect)
	#print(" | Dis. from left: " + str(point - merged_rect.get_center().x))
	#print(" | Dis. from right: " + str(-point + merged_rect.get_center().x))
