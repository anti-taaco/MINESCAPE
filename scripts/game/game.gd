extends Node2D

var playlist = "Game"
var time_elapsed : float

var game_over : bool = false
var game_won : bool = false

var random_spawn_cd : float = 1800
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var initial_list : Array
	if not Global.virus_added:
		for child in $Viruses.get_children():
			var path = child.scene_file_path
			initial_list.append(str(path.get_file()) )
		Global.virus_list.append_array(initial_list)
		Global.virus_added = true
	for child in $Viruses.get_children():
		child.free()
	
	for virus in Global.virus_list:
		$Viruses.add_child(Global.virus_to_node(virus) )
	if Modifiers.transparent_viruses:
		for virus in $Viruses.get_children():
			virus.modulate.a = 0.5
	
	var curser_count = Global.count_amount(Global.virus_list, "curser")
	if curser_count >= 1:
		for i in range(curser_count*Modifiers.additional_cursers ):
			$Viruses.add_child(Global.virus_to_node("curser.tscn"))
		var count = 0
		for item in $Viruses.get_children():
			if item is Curser:
				item.history_max += count
				count += 30
	print($Viruses.get_children())
	
	var bcod_count = Global.count_amount(Global.virus_list, "bcod")
	if bcod_count > 1:
		var count = 0
		for item in $Viruses.get_children():
			if item is BCOD:
				if count < bcod_count-1:
					item.free()
					count += 1
				else:
					item.volley_amount += count
	
	Selection.add_temp_virus(Modifiers.random_enemy_amount, "virus choices", "virus_list")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.mouse_outside:
		get_tree().paused = true
	
	if not game_over:
		time_elapsed += delta
	
	if Modifiers.random_enemy_spawning:
		random_enemy_spawning(delta, Modifiers.random_enemy_spawn_amount)
	for virus in Global.temp_viruses:
		$Viruses.add_child(Global.virus_to_node(virus) )
		Global.temp_viruses.erase(virus)
		
	if game_won:
		Global.take_screenshot()
		Global.level += 1
		Global.board_scaling()
		get_tree().change_scene_to_file("res://scenes/intermission.tscn")

func random_enemy_spawning(delta : float, num : int):
	if timer <= random_spawn_cd * delta:
		timer += delta
	else:
		timer = 0
		Audio.bcod_lunge()
		Selection.add_temp_virus(num, "virus choices", "virus_list")
		
