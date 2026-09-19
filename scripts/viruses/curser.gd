class_name Curser
extends CharacterBody2D

@onready var player: Node2D
var cursor: Node2D

var pos : Vector2
var pos_history = []
var history_max : int = 100 + Modifiers.cursor_distance
var time : float = 0
var spawn_time : float = 250
var inactive_time : float = spawn_time + 50
var active : bool = false

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	
	var v_scale = Vector2(Modifiers.cursor_scale, Modifiers.cursor_scale)
	$Line2D.width *= Modifiers.cursor_scale
	$Sprite2D.scale += v_scale-Vector2(1,1)
	$Area2D/CollisionShape2D.shape.size *= v_scale

func _physics_process(delta: float) -> void:
	#var pos = cursor.mouse_pos
	#pos_history.append(pos)
	#if pos_history.size() > history_max:
		#pos_history.pop_front()
	if time <= inactive_time * delta:
		time += delta
		
	if time > spawn_time * delta:
		follow_cursor()
	if time > inactive_time * delta:
		active = true
	leave_trail()

func follow_cursor():
	var pos = cursor.mouse_pos
	pos_history.append(pos)
	if pos_history.size() > history_max:
		pos_history.pop_front()
	global_position = pos_history[0]

func leave_trail():
	$Line2D.global_position = Vector2(0, 0)
	$Line2D.global_rotation = 0
	$Line2D.add_point(global_position)
	
	# Remove the oldest point if the trail gets too long
	if $Line2D.get_point_count() > 6 * Modifiers.cursor_scale:
		$Line2D.remove_point(0)

func _on_area_2d_mouse_entered() -> void:
	if active:
		print("Curser hit")
		player.take_damage(1, $Sprite2D.texture)
