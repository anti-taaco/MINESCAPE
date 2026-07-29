extends CharacterBody2D

var player : Node2D
var camera : Camera2D
@onready var outline: Line2D = $Screen/Line2D

var microgame_path
var microgame_list
var chosen_game
var active : bool = false
var completed : bool = false

var timer : float = 0
var spawn_time : float = 120 #1500, 120 for testing
var game_time : float = 0
var game_duration : float = 1200

func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	camera = Global.find_node_in_parent(player, "Camera")
	microgame_path = "res://scenes/viruses/parts/microgames/"
	microgame_list = DirAccess.get_files_at(microgame_path)
	microgame_list = Global.store_scenes(microgame_list)
	
	var points = $Screen.polygon
	for i in range(points.size() ):
		outline.add_point(points[i])
	outline.add_point(points[0] )
	teleport()

func _physics_process(delta: float) -> void:
	if timer > spawn_time * delta and not active:
		active = true
		var rand = randi_range(0, microgame_list.size()-1)
		chosen_game = microgame_list[rand]
		var path : NodePath = NodePath(microgame_path + str(chosen_game) )
		var loaded = load(path)
		var node = loaded.instantiate()
		
		$Microgame.add_child(node)
		teleport()
	else: if not active:
		timer += delta
	
	if active:
		self.visible = true
		if completed:
			reset_times()
		
		if game_time > game_duration * delta:
			reset_times()
			player.take_damage(1, true)
		else:
			game_time += delta
		$Label.text = str(int(game_duration*delta-game_time)) + "s"
	else:
		self.visible = false
		$Label.text = ""

func set_microgame():
	pass

func teleport():
	var size = Vector2(192, 108)
	var x_point = camera.global_position.x + randf_range(camera.left_edge, camera.right_edge-size.x)
	var y_point = camera.global_position.y + randf_range(camera.bottom_edge-size.y, camera.top_edge)
	global_position = Vector2(x_point, y_point)

func reset_times():
	timer = 0
	game_time = 0
	active = false
	completed = false
	
	for game in $Microgame.get_children():
		game.queue_free()
