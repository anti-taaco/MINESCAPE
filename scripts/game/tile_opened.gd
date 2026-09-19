extends TileMapLayer
@onready var t_grid: TileMapLayer = $"../TileMapLayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_grid()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_grid():
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
		for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
			set_cell(Vector2(i, j), 0, Vector2(0,0))
