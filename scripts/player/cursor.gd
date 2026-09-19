extends Node2D

@onready var player: Node2D = get_parent()
var stats : Resource
var game : Node2D

@onready var camera: Camera2D = $"../Camera"
@onready var label: Label = $"../GameUI/Label"
@onready var game_ui: CanvasLayer = $"../GameUI"

@onready var t_grid: TileMapLayer = $"../../CanvasLayer/Board/TileMapLayer"
@onready var t_num: TileMapLayer = $"../../CanvasLayer/Board/TileMapNumbers"
@onready var t_flag: TileMapLayer = $"../../CanvasLayer/Board/TileMapFlag"
@onready var t_open: TileMapLayer = $"../../CanvasLayer/Board/TileMapOpened"
var mine_img = preload("res://assets/images/board/tiles/mine.png")

var speed : float = 3
var ability_uses : int = 1 + Modifiers.extra_ability_uses

var can_click : bool = true
var grid_blocked : bool = false
var opened : int = 0
var safe_clicks : int = 0
var ab_clicks : int = 0

var mouse_pos : Vector2
var tile_mouse_pos : Vector2

var e_time : float = 0
var explode_limit : float = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(camera.global_position)
	game = get_tree().get_current_scene()
	stats = player.p_class
	update_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_ui()
	mouse_pos = get_global_mouse_position()
	#print(mouse_pos)
	$Area2D.global_position = mouse_pos
	
	if $Area2D.has_overlapping_areas() and grid_blocked:
		can_click = false
	else:
		can_click = true
	
	tile_mouse_pos = t_grid.local_to_map(mouse_pos)
	var atlas_coords = t_grid.get_cell_atlas_coords(tile_mouse_pos)
	
	if opened == t_grid.w * t_grid.h - count_mines() and opened != 0:
		game.game_over = true
		if player.lives >= 1:
			game.game_won = true
	if Modifiers.flag_all_tiles and t_flag.count_no_flags() != 0:
		game.game_over = false
		game.game_won = false
	
	var dir_x := Input.get_axis("left", "right")
	var dir_y := -Input.get_axis("down", "up")
	#if Input.is_action_just_pressed("M1"):
		#camera.global_position = mouse
		#print(camera.global_position)
	if dir_x:
		camera.global_position.x += speed*dir_x
	if dir_y:
		camera.global_position.y += speed*dir_y
	
	if Modifiers.fast_tile_opening:
		fast_tile_opening(delta)
	
	if Input.is_action_just_pressed("M1") and can_open(tile_mouse_pos) and can_click:
		e_time = 0
		ab_clicks += 1
		if opened == 0:
			t_num.set_mines(tile_mouse_pos)
			reveal_area(tile_mouse_pos, Modifiers.first_open_size)
			print("START")
		t_flag.clear_flags()
		if t_num.get_cell_source_id(tile_mouse_pos) == 9:
			if defuse_chance():
				player.take_damage(1+Modifiers.mine_add_damage, mine_img, true)
				Audio.player_mine()
		else:
			safe_clicks += 1
			if Modifiers.number_hide_allowed:
				if safe_clicks % Modifiers.number_hide_rate == 0:
					t_num.set_cell(tile_mouse_pos, 10, t_num.get_cell_atlas_coords(tile_mouse_pos), 0)
			if heal_chance():
				player.lives += 1
			Audio.player_open()
		t_grid.reveal_space(tile_mouse_pos)
		if aoe_chance():
			reveal_area(tile_mouse_pos, 1)
		print(tile_mouse_pos)
	opened = count_opened()
	
	if Input.is_action_just_pressed("M2"):
		var id = Modifiers.flag_id
		if id == 1:
			if can_open(tile_mouse_pos):
				t_flag.set_cell(tile_mouse_pos, 0, Vector2i(0, 0))
				print("flag")
			elif t_flag.get_cell_source_id(tile_mouse_pos) == 0:
				t_flag.set_cell(tile_mouse_pos, -1)
				print("unflag")
	
	if Input.is_action_just_pressed("Ability") and can_open(tile_mouse_pos) and ability_uses > 0:
		var id = Modifiers.ab_id
		if id == 1 and opened != 0:
			reveal_area(tile_mouse_pos, 1)
			ability_uses -= 1
	
	if Input.is_action_just_pressed("Alt Ability") and can_open(tile_mouse_pos):
		var id = Modifiers.alt_id
		if id == 1 and not player.above_max_lives():
			if Global.bits >= 400:
				Global.bits -= 400
			player.lives += 1
	
	if ab_clicks >= 35:
		ability_uses += 1
		ab_clicks = 0
	
	if Input.is_action_just_pressed("full clear"):
		player.lives = 0
		t_grid.clear_grid()
		print(count_mines()- t_flag.count_flags())
		
	if Input.is_action_just_pressed("win game"):
		t_grid.clear_grid()
		print(count_mines()- t_flag.count_flags())
	if player.lives <= 0:
		print("you suck")
		t_grid.clear_grid()

func can_open(pos):
	return t_grid.get_cell_source_id(pos) == 0 and t_flag.get_cell_source_id(pos) != 0

func count_opened():
	var count = 0
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
		for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
			if t_grid.get_cell_source_id(Vector2i(i,j)) != 0:
				count += 1
	return count

func count_mines():
	var count = 0
	for i in range(t_grid.top_left.x, t_grid.bottom_right.x+1):
		for j in range(t_grid.top_left.y, t_grid.bottom_right.y+1):
			if t_num.get_cell_source_id(Vector2i(i,j)) == 9 and t_grid.get_cell_source_id(Vector2i(i, j)) == -0:
				count += 1
	return count 

func defuse_chance():
	var range = Global.favorable_rng(0, 100, Modifiers.luck_factor, 1, 1)
	if range >= Modifiers.defuse_chance:
		return true
	else:
		return false

func aoe_chance():
	var range = Global.favorable_rng(0, 100, Modifiers.luck_factor, 1, 1)
	print(range)
	print(range <= Modifiers.aoe_open_chance)
	if range <= Modifiers.aoe_open_chance:
		return true
	else:
		return false

func heal_chance():
	var range = Global.favorable_rng(0, 100, Modifiers.luck_factor, 1, 1)
	print(range)
	print(range <= Modifiers.heal_chance)
	if range <= Modifiers.heal_chance:
		return true
	else:
		return false

func reveal_area(pos, tile):
	for i in range(-tile, tile+1):
		for j in range(-tile, tile+1):
			var offset = Vector2(i, j)
			if t_num.get_cell_source_id(pos + offset) != 9:
				t_grid.reveal_space(pos + offset)

func fast_tile_opening(delta : float):
	if e_time <= explode_limit * delta:
		e_time += delta
	else:
		e_time = 0
		Audio.player_mine()
		player.take_damage(1, mine_img)
	if e_time >= explode_limit * delta - 3:
		Audio.sleep_wake()
	
func debug_mode():
	pass

func update_ui():
	game_ui.lives = player.lives
	game_ui.tile_pos = tile_mouse_pos
	game_ui.mines = count_mines() - t_flag.count_flags()
	game_ui.time = game.time_elapsed
	game_ui.game_won = game.game_won
	game_ui.ability_uses = ability_uses


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("blocks_grid"):
		can_click = false
		grid_blocked = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("blocks_grid"):
		can_click = true
		grid_blocked = false
