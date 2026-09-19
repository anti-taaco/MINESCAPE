extends CharacterBody2D

var player : Node2D
var cursor : Node2D
var camera : Camera2D
var sprite : AnimatedSprite2D
var content

var cursor_inside : bool = false
var clicks : int = 0
var clicks_required : int = 2
var time : float = 0
var explode_time : float = 900 * Modifiers.content_explode_multiplier

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	camera = Global.find_node_in_parent(player, "Camera")
	sprite = Global.find_node_in_parent(self, "AnimatedSprite2D")
	content = get_parent().get_parent()
	
	var x_point = camera.global_position.x + randf_range(camera.left_edge, camera.right_edge)
	var y_point = camera.global_position.y + randf_range(camera.bottom_edge, camera.top_edge)
	global_position = Vector2(x_point, y_point)

func _physics_process(delta: float) -> void:
	if time <= explode_time * delta:
		time += delta
	else:
		print("Content hit")
		player.take_damage(1, $Sprite2D.texture, true)
		Audio.content_active_stop()
		Audio.content_hit()
		queue_free()
	
	if time >= explode_time * delta * 2/3:
		Audio.content_active()
		sprite.play("breaking")
	else: if time >= explode_time * delta * 1/3:
		sprite.play("partially breaking")
	else:
		sprite.play("default")
	
	if cursor_inside and Input.is_action_just_pressed("M1"):
		clicks += 1
		Audio.player_open()
		cursor.can_click = false
	
	if clicks >= clicks_required:
		Audio.content_active_stop()
		queue_free()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		#_on_area_2d_mouse_exited()


func _on_area_2d_mouse_entered() -> void:
	cursor_inside = true
	cursor.can_click = false
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	

func _on_area_2d_mouse_exited() -> void:
	cursor_inside = false
	cursor.can_click = true
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
