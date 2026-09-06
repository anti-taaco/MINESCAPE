extends CharacterBody2D

var camera: Node2D
var cursor : Node2D
@onready var player: Node2D = %Player
var sprite: AnimatedSprite2D

var speed = 600
var direction
var pos
var pos_points : Array
var bits_taken : int = 400

var time : Array = [0,0,0]
var attack_time : float = 160
var prepare_duration : float = 40
var attack_duration : float = 15
var active = false
var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos_points.resize(int(attack_duration+1) )
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	sprite = Global.find_node_in_parent(self, "AnimatedSprite2D")
	camera = Global.find_node_in_parent(player, "Camera")
	
	var window = get_viewport().get_visible_rect()
	var rand_x = randf_range(-window.size.x/2, window.size.x/2)
	var rand_y = randf_range(-window.size.y/2, window.size.y/2)
	global_position.x = rand_x
	global_position.y = rand_y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pos = cursor.mouse_pos
	if active:
		$Line2D.visible = true
		sprite.play("attacking")
	else:
		$Line2D.visible = false
		rotation_degrees = 0
		sprite.play("idle")
	move_and_slide()
	if rotation_degrees > -90 and rotation_degrees < 90:
		sprite.flip_v = false
	else:
		sprite.flip_v = true
	
	if time[0] > attack_time * delta and not active:
		Audio.bitecoin_active()
		look_at(pos)
		direction = global_position.direction_to(pos)
		create_visual_indicator(delta)
		$Line2D.top_level = false
		active = true
	else:
		time[0] += delta
	
	if active:
		if time[1] > prepare_duration * delta:
			attacking = true
		else:
			time[1] += delta
	
	if attacking:
		#print($Line2D.points[$Line2D.get_point_count()-1])
		if time[2] > attack_duration * delta:
			time = [0,0,0]
			velocity = Vector2(0,0)
			active = false
			attacking = false
			randomize_times()
		else:
			velocity = speed * direction
			if $Line2D.get_point_count() > 0:
				$Line2D.remove_point($Line2D.get_point_count()-1)
			time[2] += delta

func create_visual_indicator(delta : float):
	var distance = speed*delta*(attack_duration+1)
	distance /= attack_duration
	for i in range(attack_duration+1):
		$Line2D.add_point( to_local(global_position + Vector2(distance, distance)*i*direction ) )

func delete_visuals():
	pos_points.clear()
	$Line2D.clear_points()
	pos_points.resize(int(attack_duration) )

func randomize_times():
	attack_time = Global.favorable_rng(40, 100, Modifiers.luck_factor, 2, 2)

func _on_area_2d_mouse_entered() -> void:
	print("Bitecoin hit")
	Audio.bitecoin_hit()
	if Global.bits >= bits_taken and not player.invincible:
		Global.bits -= bits_taken
	else: if Global.bits < bits_taken:
		Global.bits = 0
		player.take_damage(3, false)
