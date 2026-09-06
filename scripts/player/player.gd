extends Node2D

@export var p_class : Resource

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
		
func take_damage(dmg : int, bypass : bool):
	if bypass or not invincible:
		lives -= dmg
		i_frames = 0
		invincible = true
		for i in range(dmg):
			Global.bits -= Modifiers.bits_lost_on_hit
		$Cursor.time = 0
		Audio.player_hit()
	else:
		print("invincible")
