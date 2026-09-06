extends Node2D

var camera: Node2D
@onready var player: Node2D = %Player
@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var time : Array = [0,0,0]
var spawn_time : float
var duration : float = 150
var open_duration : float = 6 * Modifiers.sleep_awake_multiplier
var active = false
var open = false

var pos : Vector2
var pos_history = [Vector2(0,0), Vector2(0,0)]
var moving : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	camera = Global.find_node_in_parent(player, "Camera")
	randomize_spawn_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position = camera.global_position
	
	if time[0] > spawn_time * delta:
		active = true
	else: if not player.invincible:
		time[0] += delta
	
	pos = get_global_mouse_position()
	pos_history.append(pos)
	if pos_history.size() > 2:
		pos_history.pop_front()
	mouse_movement()
	
	if open:
		sprite.play("awake")
	else:
		sprite.play("asleep")
	
	if active:
		Audio.sleep_active()
		sprite.visible = true
		scale = Vector2(0.4,0.4)
		if time[1] > duration * delta:
			open = true
			Audio.sleep_active_stop()
			Audio.sleep_wake()
		else:
			time[1] += delta
			
		if not moving and time[1] >= 30 * delta:
			time[1] += 75 * delta
	else:
		sprite.visible = false
	
	if open:
		if time[2] > open_duration * delta:
			randomize_spawn_time()
			time = [0,0,0]
			active = false
			open = false
		else:
			time[2] += delta
			
		if moving:
			Audio.sleep_wake_stop()
			Audio.sleep_hit()
			player.take_damage(1, false)

func mouse_movement():
	var mouse_vel = Input.get_last_mouse_velocity()
	if mouse_vel == Vector2(0,0):
		moving = false
	else:
		moving = true

func randomize_spawn_time():
	spawn_time = Global.favorable_rng(400, 750, Modifiers.luck_factor, 2, 2)
