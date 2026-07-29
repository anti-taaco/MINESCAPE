extends Node

@onready var t_grid: TileMapLayer
@onready var t_num: TileMapLayer
@onready var t_flag: TileMapLayer
@onready var t_open: TileMapLayer

var debug : bool = true

var p_class : Resource
var bits : int = 0 #0
var level : int = 1 #1
var game_over : bool = false

var current_mode : Window.Mode
var mouse_outside : bool = false

# BOARD SETTINGS
var width : int = 5
var height : int = 5
var border : int = 2
var mines : int = 3
var board_pos : Vector2 #= Vector2(0,0)

var virus_added : bool = false
var virus_list : Array[String]
var temp_viruses : Array[String]

# BUGS
var bug_list : Array[String]
var bug2_list : Array[String]

# UPGRADES
var upgrade_list : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	current_mode = get_window().mode
	t_grid = get_tree().get_first_node_in_group("TileMapLayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var window: Vector2 = DisplayServer.window_get_size()
	var viewport: Rect2 = get_viewport().get_visible_rect()
	var has_horizontal_bars: bool = window.x > viewport.size.x
	var has_vertical_bars: bool = window.y > viewport.size.y
	
	if has_horizontal_bars or has_vertical_bars:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var inside_viewport: bool = Rect2(Vector2.ZERO, viewport.size).has_point(mouse_pos)
		if inside_viewport:
			mouse_outside = false
		else:
			mouse_outside = true
	if not get_window().has_focus():
		mouse_outside = true
	
	if not mouse_outside:
		get_tree().paused = false
	
	if Input.is_action_just_pressed("fullscreen"):
		if get_window().mode != get_window().MODE_EXCLUSIVE_FULLSCREEN and get_window().mode != get_window().MODE_FULLSCREEN:
			current_mode = get_window().mode
		full_screen(current_mode)
	
	if Input.is_action_just_pressed("Debug"):
		debug = !debug
	
	if debug:
		if Input.is_action_just_pressed("refresh"):
			get_tree().reload_current_scene()
		
		if Input.is_key_pressed(KEY_1):
			get_tree().change_scene_to_file("res://scenes/game.tscn")

func board_scaling():
	width += randi_range(1, 2)
	height += randi_range(1, 2)
	mines += randi_range(2, 4)

func full_screen(current_mode):
	if get_window().mode == get_window().MODE_FULLSCREEN:
		get_window().mode = current_mode
	else:
		get_window().mode = get_window().MODE_FULLSCREEN

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		mouse_outside = false
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		mouse_outside = true

func favorable_rng(min, max, rolls, mode, type):
	#mode 1 = lowest, mode 2 = highest
	#mode 3 = closest to avg, mode 4 = furthest from avg
	#type 1 = int, type 2 = float
	var num = 0
	var avg = (min+max)/2
	var roll_list : Array
	roll_list.resize(rolls)
	for i in range(rolls):
		if type == 1:
			roll_list[i] = randi_range(min, max)
		else: if type == 2:
			roll_list[i] = randf_range(min, max)
			
		if i == 0:
			num = roll_list[i]
		else: if mode <= 2:
			num = compare(roll_list[i], roll_list[i-1], mode)
		else: if mode >= 3:
			num = compare_with_value(roll_list[i], roll_list[i-1], mode, avg)
	return num

func compare(a, b, mode):
	var num = b
	if mode == 1: #lowest
		if a < b:
			return a
	else: if mode == 2: #highest
		if a > b:
			return a
	return num

func compare_with_value(a, b, mode, value):
	var num = b
	if mode == 3: #closest to avg
		if abs(a-value) < abs(b-value):
			return a
	else: if mode == 4: #furthest from avg
		if abs(a-value) > abs(b-value):
			return a
	return num

func count_amount(list, thing):
	var count = 0
	thing = thing.replace(".tres", "")
	thing = thing.replace(".tscn", "")
	for item in list:
		if str(item).contains(thing):
			count += 1
	return count

func virus_to_node(virus):
	var virus_path : NodePath = NodePath("res://scenes/viruses/" + virus)
	var loaded = load(virus_path)
	var node = loaded.instantiate()
	return node
	
func store_resources(selection : Array[String]):
	var list = []
	for thing in selection:
		if thing.ends_with(".tres"):
			list.append(thing)
	return list

func store_scenes(selection : Array[String]):
	var list = []
	for thing in selection:
		if thing.ends_with(".tscn"):
			list.append(thing)
	return list

func virus_to_resource(virus):
	var virus_path : NodePath = NodePath("res://scripts/resources/virus choices/" + virus)
	var resource = load(virus_path)
	return resource

func path_to_resource(folder, thing):
	var path : NodePath
	if folder:
		path = NodePath("res://scripts/resources/" + folder + "/" + thing)
	else:
		path = NodePath("res://scripts/resources/" + thing)
	var resource = load(path)
	return resource

func find_node_in_scene(node, name : String):
	for child in node.get_tree().get_current_scene().get_children():
		if child.name == name:
			return child

func find_node_in_parent(node, name : String):
	for child in node.get_children():
		if child.name == name:
			return child
