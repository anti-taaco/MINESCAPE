extends TileMap

@onready var camera: Camera2D = $"../Camera2D"
var t_size
var w = 12
var h = 12
var b = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var size = Vector2(get_viewport().size.y/(w+b), get_viewport().size.y/(h+b) )
	tile_set.tile_size = size
	t_size = tile_set.tile_size
	print("Tile size: " + str(t_size))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_grid():
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y - t_size.y * b
	var center_point = get_viewport_rect().get_center()
	var cam_x = camera.global_position.x
	var cam_y = camera.global_position.y
	
	for i in range(0, w):
		for j in range(0, h):
			var rect = Rect2(-cam_x-height/2 + i*t_size.x, -cam_y-height/2 + j*t_size.y, t_size.x, t_size.y)
			var color
			if (i % 2 == j % 2):
				color = Color(1, 0, 0)
			else:
				color = Color(0, 0, 1)
			draw_rect(rect, color)
	
func _draw():
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y - t_size.y * b
	var center_point = get_viewport_rect().get_center()
	var cam_x = camera.global_position.x
	var cam_y = camera.global_position.y
	
	var merged_rect = Rect2(-height/2, cam_y, t_size.x, t_size.y)
	for i in range(0, w):
		for j in range(0, h):
			var rect = Rect2(-cam_x-height/2 + i*t_size.x, -cam_y-height/2 + j*t_size.y, t_size.x, t_size.y)
			var color
			if (i % 2 == j % 2):
				color = Color(1, 0, 0)
			else:
				color = Color(0, 0, 1)
			draw_rect(rect, color)
			merged_rect = merged_rect.merge(rect)
	
	var point = -height/2
	var point2 = -height/2
	merged_rect.position = Vector2(point, point2)
	#draw_rect(merged_rect, Color(0,1,0))
	print(merged_rect)
	print(" | Dis. from left: " + str(point - merged_rect.get_center().x))
	print(" | Dis. from right: " + str(-point + merged_rect.get_center().x))
