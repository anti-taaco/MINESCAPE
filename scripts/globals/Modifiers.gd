extends Node

# BUGS
var hide_mines : bool
var mine_multiplier : float
var surprise_tile_bomb : bool
var number_hide_allowed : bool
var number_hide_rate : int
var flag_all_tiles : bool

var bits_lost_on_hit : int
var viruses_to_add : int

var cursor_distance : int
var cursor_scale : float
var additional_cursers : int

var tetromino_fall_multiplier : float
var tetromino_boomerang : bool

var nyan_speed_multiplier : float

var sleep_awake_multiplier : float

var bcod_additional_lines : int
var bcod_stop_multiplier : float

var nextbot_speed_multiplier : float

var content_spawning_multiplier : float
var content_explode_multiplier : float

var ice_always_active : bool
var ice_speed_mult : float

var choice_removals : int
var mine_add_damage : int
var random_enemy_spawning : bool
var random_enemy_amount : int
var random_enemy_spawn_amount : int
var fast_tile_opening : bool

# UPGRADES
var extra_lives : int
var heal_chance : int

var i_frame_multiplier : float
var bit_gain_multiplier : float
var extra_ability_uses : int
var ability_upgraded : bool

var luck_factor : int
var defuse_chance : float
var aoe_open_chance : float
var first_open_size : int

var transparent_viruses : bool

var flag_id : int
var ab_id : int
var alt_id : int

var live_execution : bool

var scene

func _ready() -> void:
	reset()
	if Global.p_class:
		flag_id = Global.p_class.flag_id #Global.p_class.flag_id
		ab_id = Global.p_class.ability_id #Global.p_class.ability_id
		alt_id = 0 #Global.p_class.alt_ability_id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scene = get_tree().get_current_scene()
	if live_execution and scene:
		scene.add_child(Global.virus_to_node("nyan_cat.tscn"))

func reset() -> void:
	hide_mines = false #false
	mine_multiplier = 1 #1
	surprise_tile_bomb = false #false
	number_hide_allowed  = false #false
	number_hide_rate = 0 #0
	flag_all_tiles = false #false
	
	bits_lost_on_hit = 0 #0
	viruses_to_add = 0 #0

	cursor_distance = 0 #0
	cursor_scale = 1 #1
	additional_cursers = 0 #0

	tetromino_fall_multiplier = 1 #1
	tetromino_boomerang = false #false

	nyan_speed_multiplier = 1 #1

	sleep_awake_multiplier = 1 #1

	bcod_additional_lines = 0 #0
	bcod_stop_multiplier = 1 #1

	nextbot_speed_multiplier = 1 #1

	content_spawning_multiplier = 1 #1
	content_explode_multiplier = 1 #1

	ice_always_active = false # true
	ice_speed_mult = 1 #1

	choice_removals = 0 #0
	mine_add_damage = 0 #0
	random_enemy_spawning = false #false
	random_enemy_amount = 0 #0
	random_enemy_spawn_amount = 0 #0
	fast_tile_opening = false #false

	# UPGRADES
	extra_lives = 0 #0
	heal_chance = 0 #0

	i_frame_multiplier = 1 #1
	bit_gain_multiplier = 1 #1
	extra_ability_uses = 0 #0
	ability_upgraded = false #false

	luck_factor = 1 #1
	defuse_chance = 0 #0
	aoe_open_chance = 0 #0
	first_open_size = 0 #0

	transparent_viruses = false #false

	flag_id = 1 #Global.p_class.flag_id
	ab_id = 1 #Global.p_class.ability_id
	alt_id = 0 #0

	live_execution = false
