extends Node2D

@export var p_class : Resource
@onready var game_ui: CanvasLayer = $GameUI

var max_lives : int = 3 + Modifiers.extra_lives
var lives : int

var invincible = true
var max_frames : float = 150 * Modifiers.i_frame_multiplier
var i_frames : float = 0

func _ready() -> void:
	Global.p_class = p_class
	
	if max_lives <= 0:
		max_lives = 1
	lives = max_lives

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if i_frames <= max_frames * delta:
		i_frames += delta
		Input.set_default_cursor_shape(Input.CURSOR_WAIT)
		invincible = true
	else:
		if Input.get_current_cursor_shape() == Input.CURSOR_WAIT:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		invincible = false
	
	if lives > max_lives:
		lives = max_lives
		
func take_damage(dmg : int, texture : Texture2D = null, bypass : bool = false):
	if bypass or not invincible:
		invincible = true
		lives -= dmg
		i_frames = 0
		if texture:
			game_ui.get_node("IconV").texture = texture
		
		for i in range(dmg):
			Global.bits -= Modifiers.bits_lost_on_hit
		$Cursor.e_time = 0
		Audio.player_hit()
	else:
		print("invincible")


func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
