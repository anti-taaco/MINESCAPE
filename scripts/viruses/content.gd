extends Node2D

var player: Node2D
var cursor: Node2D
var camera : Camera2D

var time : float = 0
var spawn_time : float = 300 * Modifiers.content_spawning_multiplier

func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	camera = Global.find_node_in_parent(player, "Camera")

func _process(delta: float) -> void:
	if time <= spawn_time * delta:
		time += delta
	else:
		print("Spawned")
		var spawnable = load("res://scenes/viruses/parts/content_spawn.tscn").instantiate()
		$Spawnables.add_child(spawnable)
		Audio.content_pop()
		time = 0
