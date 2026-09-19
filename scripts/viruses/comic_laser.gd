extends Line2D

var player : Node2D
var camera : Node2D
@onready var area_col: CollisionShape2D = $Area2D/CollisionShape2D
@onready var col: CollisionShape2D = $CollisionShape2D
@onready var area: Area2D = $Area2D

var vertical : bool

var time = [0,0]
var warning_time : float = 40
var active_time : float = 30

var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	camera = Global.find_node_in_parent(player, "Camera")
	
	var cam_pos = camera.global_position
	var win_size = get_viewport().get_visible_rect().size
	
	var rot_deg : float = randf_range(0, 360)
	rotation_degrees = rot_deg
	var coord : float = randf_range(-win_size.x/3, win_size.x/3)
	#add_point(Vector2(0,0) + cam_pos)
	#add_point(Vector2(0,0) + cam_pos)
	var line_length = get_point_position(0).distance_to(get_point_position(1) )
	area_col.shape.size = Vector2(line_length, width)
	area.global_position = global_position
	global_position = Vector2(coord, 0) + cam_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time[0] >= warning_time * delta:
		active = true
		if not $Blast.playing:
			$Blast.play()
	else:
		time[0] += delta
		
	if active:
		area_col.disabled = false
		default_color = Color("bfffff")
		#Audio.comic_blast()
		if time[1] >= active_time * delta:
			#Audio.comic_blast_stop()
			queue_free()
		else:
			time[1] += delta
	else:
		area_col.disabled = true
		default_color = Color("0000ff7d")


func _on_area_2d_mouse_entered() -> void:
	print("Comic hit")
	player.take_damage(1, get_parent().get_parent().find_child("Sprite2D").texture )
