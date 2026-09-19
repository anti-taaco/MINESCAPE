class_name Ice
extends CharacterBody2D

@onready var player: Node2D
var cursor: Node2D
var camera : Camera2D

var speed : float = 100.0 * Modifiers.ice_speed_mult
var direction
var distance

var s_timer : float = 0
var spawn_time : float = 400
var a_timer : float = 0
var active_time : float = 300

var player_inside = false

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	camera = Global.find_node_in_parent(player, "Camera")
	global_position = cursor.mouse_pos
	visible = false

func _physics_process(delta: float) -> void:
	var pos = cursor.mouse_pos
	direction = global_position.direction_to(pos)
	distance = global_position.distance_to(pos)
	velocity = speed * direction
	move_and_slide()
	if distance < speed / 100:
		global_position = pos
	
	if not visible:
		if s_timer <= spawn_time * delta:
			s_timer += delta
		else:
			s_timer = 0
			global_position = pos
			player_inside = true
			visible = true
			Audio.ice_active()
	if visible:
		if a_timer <= active_time * delta and visible:
			a_timer += delta
		else:
			a_timer = 0
			visible = false
			Audio.ice_disappear()
	
	if Modifiers.ice_always_active:
		s_timer = 9999
		a_timer = 0
		visible = true
	
	if not player_inside and visible:
		player.take_damage(1, $Sprite2D.texture)

func _on_area_2d_mouse_entered() -> void:
	player_inside = true

func _on_area_2d_mouse_exited() -> void:
	print("Ice hit")
	player_inside = false
