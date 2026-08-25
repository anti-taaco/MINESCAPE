extends TileMapLayer
@onready var t_grid: TileMapLayer = $"../TileMapLayer"
@onready var cursor: Node2D = $"../Cursor"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	clear_flags()

func count_flags():
	var count = 0
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
			for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
				var cell = Vector2i(i,j)
				if get_cell_source_id(cell) == 0:
					count += 1
	return count
	
func count_no_flags():
	var count = 0
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
			for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
				var cell = Vector2i(i,j)
				if get_cell_source_id(cell) != 0 and t_grid.get_cell_source_id(cell) == 0:
					count += 1
	return count


func clear_flags():
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
			for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
				var cell = Vector2i(i,j)
				if t_grid.get_cell_source_id(cell) != 0:
					set_cell(cell, -1, get_cell_atlas_coords(cell), 0)
