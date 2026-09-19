extends CharacterBody2D

@onready var player: Node2D = %Player

var speed = 10.0 * Modifiers.nyan_speed_multiplier
var direction = Vector2(1, 1).normalized()

var time : float
var summon_time : float = 0

func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	var window = get_viewport().get_visible_rect()
	var rand_x = randf_range(-window.size.x/2, window.size.x/2)
	var rand_y = randf_range(-window.size.y/2, window.size.y/2)
	global_position.x = rand_x
	global_position.y = rand_y
	randomize_stats()

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction.x * delta
	velocity.y = speed * direction.y * delta
	rotate(speed*0.00006)
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())
	
	if time >= summon_time * delta:
		var laser = load("res://scenes/viruses/parts/comic_laser.tscn").instantiate()
		$Lasers.add_child(laser)
		randomize_stats()
		time = 0
	else:
		time += delta
	
	move_and_slide()
	
func randomize_stats():
	summon_time = randf_range(50, 80)


func _on_area_2d_mouse_entered() -> void:
	print("comic contact hit wow you suck")
	if player:
		player.take_damage(1, $Sprite2D.texture)
