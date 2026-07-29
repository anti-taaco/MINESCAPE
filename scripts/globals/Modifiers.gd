extends Node

# BUGS
var hide_mines : bool = false #false
var mine_multiplier : float = 1 #1
var surprise_tile_bomb : bool = false #false
var number_hide_allowed : bool = false #false
var number_hide_rate : int = 0 #0
var flag_all_tiles : bool = false #false

var bits_lost_on_hit = 0 #0
var viruses_to_add : int = 0 #0

var cursor_distance : int = 0 #0
var cursor_scale : float = 1 #1
var additional_cursers : int = 0 #0

var tetromino_fall_multiplier : float = 1 #1
var tetromino_boomerang : bool = false #false

var nyan_speed_multiplier : float = 1 #1

var sleep_awake_multiplier : float = 1 #1

var bcod_additional_lines : int = 0 #0
var bcod_stop_multiplier : float = 1 #1

var nextbot_speed_multiplier : float = 1 #1

var content_spawning_multiplier : float = 1 #1
var content_explode_multiplier : float = 1 #1

# BUGS^2
var choice_removals : int = 0 #0
var mine_add_damage : int = 0 #0
var random_enemy_spawning : bool = false #false
var random_enemy_amount : int = 0 #0
var random_enemy_spawn_amount : int = 0 #0
var fast_tile_opening : bool = false #false

# UPGRADES
var extra_lives : int = 0 #0
var heal_chance : int = 1 #0

var i_frame_multiplier : float = 1 #1
var bit_gain_multiplier : float = 1 #1
var extra_ability_uses : int = 0 #0
var ability_upgraded : bool = false #false

var luck_factor : int = 1 #1
var defuse_chance : float = 0 #0
var aoe_open_chance : float = 0 #0
var first_open_size : int = 0 #0

var transparent_viruses : bool = false #false

var flag_id : int = 1 #Global.p_class.flag_id
var ab_id : int = 1 #Global.p_class.ability_id
var alt_id : int = 0 #0

func _ready() -> void:
	if Global.p_class:
		flag_id = Global.p_class.flag_id #Global.p_class.flag_id
		ab_id = Global.p_class.ability_id #Global.p_class.ability_id
		alt_id = 0 #Global.p_class.alt_ability_id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
