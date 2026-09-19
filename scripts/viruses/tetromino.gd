extends CharacterBody2D

var scene
@onready var player: Node2D
var camera : Node2D

var fall_dist : int
var time : float = 0
var fall_time : float = 34 * Modifiers.tetromino_fall_multiplier
var spawn : float = 0
var spawn_time : float = fall_time * 8
var y_dir : float = 1
var can_boomerang : bool = true

var player_inside : bool = false

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	camera = Global.find_node_in_parent(player, "Camera")
	scene = get_tree().current_scene
	var size = Vector2($Sprite2D.texture.get_width(), $Sprite2D.texture.get_height())
	var scale = $Sprite2D.scale
	fall_dist = size.y * scale.y
	spawn_in()
	
	$ColorRect.color = "ff00003f"
	$ColorRect.size = Vector2(size.x * scale.x, size.y * scale.y * 7)
	
func _physics_process(delta: float) -> void:
	if time <= fall_time * delta:
		time += delta
	else:
		global_position.y += fall_dist * y_dir
		Audio.tetromino_fall()
		time = 0
	
	if spawn <= spawn_time * delta:
		spawn += delta
	else:
		spawn = 0
		time = 0
		if Modifiers.tetromino_boomerang and can_boomerang:
			y_dir = -1
			can_boomerang = false
		else:
			y_dir = 1
			spawn_in()
			can_boomerang = true
	
	if player_inside:
		player.take_damage(1, $Sprite2D.texture)

func spawn_in():
	var view_size = get_viewport_rect().size/4
	var min = get_viewport_rect().position.x - view_size.x
	var max = get_viewport_rect().position.x + view_size.x
	#var rand = randi_range(get_viewport_rect().position.x - view_size.x, get_viewport_rect().position.x + view_size.x)
	var rand = Global.favorable_rng(min, max, Modifiers.luck_factor, 4, 2)
	global_position.x = camera.global_position.x + rand
	global_position.y = camera.global_position.y - (get_viewport_rect().size.y/2 + fall_dist*2)

func _on_area_2d_mouse_entered() -> void:
	print("Tetromino hit")
	Audio.tetromino_hit()
	player_inside = true

func _on_area_2d_mouse_exited() -> void:
	player_inside = false
