extends Node2D

@onready var selection: Control = $Selection
@onready var leet: AnimatedSprite2D = $CanvasLayer/Leet
@onready var game_screen: TextureRect = $TextureRect

var playlist = "Intermission"
var rect_size
var virus_list
var bug_list
var bug2_list
var upgrade_list

var rerolls : int = 1
var random : int
var choices : int = 3 - Modifiers.choice_removals
var shop_choices : int = 2
var choice_list : Array[int]
var breakout : bool = true
var last_chosen : int = -1

var viruses : int = 0
var bugs : int = 0
var bugs_squared : int = 0
var shop : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3-choices):
		selection.get_child(get_child_count()-1).queue_free()
	game_screen.texture = Global.screenshot
	
	if (Global.level+1) % 2 == 0:
		print("virus choose")
		viruses += 1
	if Global.level % 2 == 0:
		print("bugs choose")
		bugs += 1
	if Global.level % 10 == 0:
		print("bugs squared choose")
		bugs_squared += 1
	if Global.level % 5 == 3 or Global.level % 5 == 0:
		print("shop choose")
		shop = true
	Audio.stop_audio()
	
	rect_size = get_viewport_rect().size
	#create_selection(choices)
	
	#virus_list = Selection.virus_list
	#bug_list = Selection.bug_list
	#bug2_list = Selection.bug2_list
	#upgrade_list = Selection.upgrade_list

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_screen.texture != Global.screenshot:
		game_screen.texture = Global.screenshot
	else:
		var window = get_viewport().get_visible_rect().size
		if not game_screen.position.y < -window.y and not game_screen.position.y > window.y:
			game_screen.position += Vector2(0, -250) * delta
	
	$Label.text = "LEVEL " + str(Global.level)
	$Label2.text = "BITS: " + str(Global.bits)
	$Reroll.text = "REROLLS: " + str(rerolls)
	
	if viruses > 0:
		selection_category(viruses, "virus choices", "virus_list")
	elif bugs > 0:
		selection_category(bugs, "bug choices", "bug_list")
	elif bugs_squared > 0:
		selection_category(bugs_squared, "bug2 choices", "bug2_list")
	else:
		if shop:
			inf_selection_category(shop, "upgrade choices", "upgrade_list")
		else:
			delete_selection()
		$Continue.visible = true

func selection_category(category, folder, list):
	for i in range(category):
		if breakout:
			Selection.stack_reached(folder, list)
			choice_list = Selection.randomize_list(choices, Selection.get(list).size(), folder, list)
			print(choice_list)
			for j in range(choices):
				var cho = selection.get_child(j)
				cho.stats = Global.path_to_resource(folder, Selection.get(list)[choice_list[j] ])
			breakout = false
		if not breakout:
			continue

func inf_selection_category(category, folder, list):
	if category == true:
		if breakout:
			Selection.stack_reached(folder, list)
			if last_chosen > -1 and last_chosen < choice_list.size():
				for j in range(choices):
					var cho = selection.get_child(j)
					var cho_name
					if cho.stats is UpgradeChoice and j != last_chosen:
						cho_name = cho.stats.resource_path.get_file()
						choice_list[j] = Selection.get(list).find(cho_name)
						while true:
							var listy = Selection.randomize_list(1, Selection.get(list).size(), folder, list)
							var reroll = false
							for i in range(choices):
								if listy[0] == choice_list[i] and last_chosen != i:
									reroll = true
									break
							if not reroll:
								choice_list[last_chosen] = listy[0]
								break
			else:
				choice_list = Selection.randomize_list(choices, Selection.get(list).size(), folder, list)
			
			for j in range(choices):
				var cho = selection.get_child(j)
				cho.stats = Global.path_to_resource(folder, Selection.get(list)[choice_list[j] ])
			breakout = false

func create_selection(list_size):
	var choice_path = NodePath("res://scenes/choice.tscn")
	var choice_scene = load(choice_path)
	var choice_node = choice_scene.instantiate()
	for i in range(1, choices+1):
		var choice_dupe = choice_node.duplicate()
		choice_dupe.name = "Choice" + str(i)
		selection.add_child(choice_dupe)
		choice_dupe.global_position.x = global_position.x + (rect_size.x/(choices+1) )*i
		choice_dupe.global_position.y = rect_size.y/2

func delete_selection():
	for child in selection.get_children():
		child.queue_free()


func _on_continue_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_reroll_button_up() -> void:
	if rerolls > 0:
		breakout = true
		rerolls -= 1
	leet.play("idle")


func _on_reroll_button_down() -> void:
	leet.play("reroll")
