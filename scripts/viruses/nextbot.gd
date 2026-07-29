class_name Nextbot
extends CharacterBody2D

@onready var player: Node2D
var cursor: Node2D
var camera : Camera2D

var speed : float = 40.0
var speed_mult : float = 1.0
var max_mult : float
var direction
var distance

var timer : float = 0
var teleport_time : float = 1000

var player_inside = false

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	camera = Global.find_node_in_parent(player, "Camera")
	
	randomize_stats()
	teleport()

func _physics_process(delta: float) -> void:
	var pos = cursor.mouse_pos
	direction = global_position.direction_to(pos)
	distance = global_position.distance_to(pos)
	speed_mult = distance / 20
	if speed_mult > max_mult:
		speed_mult = max_mult
	velocity = speed * direction * speed_mult
	move_and_slide()
	print(speed)
	
	if timer <= teleport_time * delta:
		timer += delta
	else:
		self.randomize_stats()
		teleport()
		timer = 0
	
	if player_inside:
		player.take_damage(1, false)

func randomize_stats():
	speed = Global.favorable_rng(5, 20, Modifiers.luck_factor, 1, 2) * Modifiers.nextbot_speed_multiplier
	max_mult = Global.favorable_rng(5, 15, Modifiers.luck_factor, 1, 2)
	teleport_time = Global.favorable_rng(300, 720, Modifiers.luck_factor, 1, 2)

func teleport():
	var screen = get_viewport_rect()
	var edge = randi_range(1, 4) #1 = top, 2 = left, 3 = bottom, 4 = right
	var range : Vector2
	var sign : int = 1
	#neg is up, pos is down
	if edge % 2 == 0:
		range.x = screen.size.x/1.5
		range.y = randf_range(-screen.size.x/2, screen.size.x/2)
	else:
		range.x = randf_range(-screen.size.y/2, screen.size.y/2)
		range.y = screen.size.y/1.5
	if edge-2 > 0:
		sign = 1
	else:
		sign = -1
	#var x_point = camera.global_position.x + randf_range(-screen.size.x/2, screen.size.x/2)
	#var y_point = camera.global_position.y + randf_range(-screen.size.y/2, screen.size.y/2)
	var x_point = camera.global_position.x + sign * range.x
	var y_point = camera.global_position.y + sign * range.y
	global_position = Vector2(x_point, y_point)

func _on_area_2d_mouse_entered() -> void:
	print("Nextbot hit")
	player_inside = true

func _on_area_2d_mouse_exited() -> void:
	player_inside = false
