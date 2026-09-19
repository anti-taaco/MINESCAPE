extends Node2D

var camera: Node2D
@onready var player: Node2D = %Player
@onready var sprite: Sprite2D = $Sprite2D
var board : Node2D
var t_flag: TileMapLayer
var size

var time : Array = [0,0]
var spawn_time : float = 10
var duration : float = 720
var active = false

var chosen_flags : int
var flag_count : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = Vector2(0.4,0.4)
	size = sprite.get_rect().size
	player = Global.find_node_in_scene(self, "Player")
	camera = Global.find_node_in_parent(player, "Camera")
	board = get_tree().get_current_scene().get_node("CanvasLayer").get_child(0)
	t_flag = Global.find_node_in_parent(board, "TileMapFlag")
	randomize_times()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flag_count = t_flag.count_flags()
	global_position = camera.global_position + Vector2(-size.x/2*scale.x, -size.y/2*scale.y) + Vector2(camera.right_edge, camera.bottom_edge)
	$Flags.text = str(flag_count) + "/" + str(chosen_flags)
	$Time.text = str( int(time[1]) ) + "/" + str( snapped(duration*delta, 0.01) )
	
	if time[0] > spawn_time * delta:
		active = true
	else: if not player.invincible:
		time[0] += delta
	
	visible = active
	if active:
		if time[1] > duration * delta:
			player.take_damage(1, $Sprite2D.texture)
			reset()
		else:
			time[1] += delta
			
		if flag_count == chosen_flags:
			reset()

func reset():
	time[0] = 0
	time[1] = 0
	randomize_times()
	active = false

func randomize_times():
	spawn_time = Global.favorable_rng(400, 600, Modifiers.luck_factor, 2, 2)
	var mines = Global.mines
	chosen_flags = randi_range(floori(mines*0.1), ceili(mines*1.25) )
