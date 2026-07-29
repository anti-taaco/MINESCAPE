extends Node

@onready var selection: Control = $Selection

var virus_list
var bug_list
var bug2_list
var upgrade_list

var random : int
var choices : int = 3 - Modifiers.choice_removals
var shop_choices : int = 2
var choice_list : Array[int]
var breakout : bool = true
var last_chosen : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	virus_list = DirAccess.get_files_at("res://scripts/resources/virus choices/")
	virus_list = Global.store_resources(virus_list)
	bug_list = DirAccess.get_files_at("res://scripts/resources/bug choices/")
	bug_list = Global.store_resources(bug_list)
	bug2_list = DirAccess.get_files_at("res://scripts/resources/bug2 choices/")
	bug2_list = Global.store_resources(bug2_list)
	upgrade_list = DirAccess.get_files_at("res://scripts/resources/upgrade choices/")
	upgrade_list = Global.store_resources(upgrade_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func automatic_selection(amount, folder, list):
	while amount > 0:
		Selection.stack_reached(folder, list)
		var rand = randi_range(0, get(list).size()-1)
		var reroll = reroll_choice(rand, folder, list)
		if not reroll:
			var cho = Global.path_to_resource(folder, get(list)[rand] )
			if cho is VirusChoice:
				print("whata")
				cho.add_virus()
			else: if cho is UpgradeChoice:
				cho.apply_upgrade()
			else: if cho is BugChoice:
				cho.apply_bug()
			else: if cho is Bug2Choice:
				cho.apply_bug2()
			amount -= 1

func add_temp_virus(amount, folder, list):
	var i = amount
	while i > 0:
		Selection.stack_reached(folder, list)
		var rand = randi_range(0, get(list).size()-1)
		var reroll = reroll_choice(rand, folder, list)
		if not reroll:
			var cho = Global.path_to_resource(folder, get(list)[rand] )
			if cho is VirusChoice:
				cho.add_temp_virus()
			i -= 1

func randomize_list(list_size, size : int, folder, list):
	var c_list : Array[int]
	c_list.resize(list_size)
	var i = 0
	while i < list_size:
		var rand = randi_range(0, size-1)
		var reroll = reroll_choice(rand, folder, list)
		for j in range(i):
			if c_list[j] == rand:
				reroll = true
				break
		if not reroll:
			c_list[i] = rand
			i += 1
	return c_list

func reroll_choice(rand, folder, list):
	var reroll = false
	var cho = Global.path_to_resource(folder, get(list)[rand] )
	if Global.level < cho.level:
		reroll = true
	if "virus_needed" in cho:
		for virus in cho.virus_needed:
			if Global.count_amount(Global.virus_list, virus) < 1:
				reroll = true
				break
	return reroll

func stack_reached(folder, list_name):
	var count : int = 0
	var list = get(list_name)
	var erase_list : Array
	for thing in list:
		var cho = Global.path_to_resource(folder, thing)
		if cho.can_choose == false or ( cho.stack > 0 and Global.count_amount(Global.get(list_name), thing) >= cho.stack):
			erase_list.append(thing)
	for bye in erase_list:
		count += 1
		list.erase(bye)
	return count


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
