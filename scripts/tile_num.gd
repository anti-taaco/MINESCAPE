extends TileMapLayer

@onready var t_grid: TileMapLayer = $"../TileMapLayer"
var t_size : Vector2i
var w : int
var h : int
var b : int
var mines : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	t_size = t_grid.t_size
	tile_set.tile_size = t_size
	w = t_grid.w
	h = t_grid.h
	b = t_grid.b
	mines = t_grid.mines


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_mines(first_tile):
	print(first_tile)
	var atlas_coords = Vector2i(0,0)
	var mines_r = [0]
	var mines_c = [0]
	mines_r.resize(mines)
	mines_c.resize(mines)
	var i = 0
	while i < mines:
		var row = randi_range(t_grid.top_left.x, t_grid.bottom_right.x)
		var col = randi_range(t_grid.top_left.y, t_grid.bottom_right.y)
		var equal = false
		for j in range(i):
			if row == mines_r[j] and col == mines_c[j]:
				equal = true
				break
		
		if row == w and col == h:
			equal = true
		if row == first_tile.x and col == first_tile.y:
			equal = true
			
		if equal:
			i -= 1
		else:
			mines_r[i] = row
			mines_c[i] = col
			set_cell(Vector2(row, col), 9, atlas_coords)
		i += 1
	
	#for j in range(mines):
		#var cRow = mines_r[i]
		#var cCol = mines_c[i]
		#set_cell(Vector2(cRow, cCol), 9, atlas_coords)
	
	#change below with top_left and bottom_right variables | odd number problem
	for r in range(w):
		for c in range(h):
			var cRow = t_grid.top_left.x + r
			var cCol = t_grid.top_left.y + c
			var id = get_cell_source_id(Vector2(cRow, cCol))
			if id != 9:
				set_cell(Vector2(cRow, cCol), check_adjacent(cRow, cCol), atlas_coords)

func check_adjacent(row, col):
	var num = 0
	#print(Vector2(row, col) )
	for r in range(-1, 2):
		for c in range(-1, 2):
			var cRow = row+r
			var cCol = col+c
			var checkSpace = true
			if cRow < t_grid.top_left.x or cRow > t_grid.bottom_right.x: #-w/2, w/2
				checkSpace = false
			if cCol < t_grid.top_left.y or cCol > t_grid.bottom_right.y: #-h/2, h/2
				checkSpace = false
				
			if checkSpace and get_cell_source_id(Vector2(cRow, cCol) ) == 9:
				num += 1
	return num

func count_mines():
	var count = 0
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
		for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
			if get_cell_source_id(Vector2i(i,j)) == 9:
				count += 1
	return count
