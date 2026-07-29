extends CharacterBody2D

@onready var player: Node2D = %Player

var speed = 200.0 * Modifiers.nyan_speed_multiplier
var direction = Vector2(1, 1).normalized()

func _ready() -> void:
	player = Global.find_node_in_scene(self, "Player")
	global_rotation_degrees = 45
	var window = get_viewport().get_visible_rect()
	var rand_x = randf_range(-window.size.x/2, window.size.x/2)
	var rand_y = randf_range(-window.size.y/2, window.size.y/2)
	global_position.x = rand_x
	global_position.y = rand_y

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction.x * delta
	velocity.y = speed * direction.y * delta
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		direction = direction.bounce(collision.get_normal())
		rotate(get_angle_to(direction) )
		Audio.nyan_bounce()
	leave_trail()
	
	move_and_slide()

func leave_trail():
	$Line2D.global_position = Vector2(0, 0)
	$Line2D.global_rotation = 0
	$Line2D.add_point(global_position)
	
	if $Line2D.get_point_count() > 16:
		$Line2D.remove_point(0)

func _on_area_2d_mouse_entered() -> void:
	print("Nyan Cat hit")
	player.take_damage(1, false)
