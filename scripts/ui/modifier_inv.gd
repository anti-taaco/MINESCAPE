extends Control

@onready var mod_items: Control = $"Mod Items"
@onready var color_rect: ColorRect = $ColorRect
@onready var virus: BoxContainer = $"Mod Items/Virus"
@onready var bug: BoxContainer = $"Mod Items/Bug"
@onready var upgrade: BoxContainer = $"Mod Items/Upgrade"
@onready var bug_2: BoxContainer = $"Mod Items/Bug2"
var MODIFIER_ITEM = load("uid://cp0av3xqya60x")

var virus_list = Global.store_scenes_as_resources(Global.virus_list)
var bug_list = Global.store_resources(Global.bug_list)
var bug2_list = Global.store_resources(Global.bug2_list)
var upgrade_list = Global.store_resources(Global.upgrade_list)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#virus_list.append("tetromino.tres")
	#virus_list.append("curser.tres")
	#virus_list.append("nyan_cat.tres")
	#virus_list.append("curser.tres")
	virus_list.sort()
	
	#bug_list.append("transparency.tres")
	bug_list.sort()
	
	bug2_list.sort()
	
	
	#upgrade_list.append("1-up.tres")
	upgrade_list.sort()
	
	add_list_to_inv(virus_list, "virus")
	add_list_to_inv(bug_list, "bug")
	add_list_to_inv(bug2_list, "bug2")
	add_list_to_inv(upgrade_list, "upgrade")


# FIX MOVING DOWN ISSUE
func _process(delta: float) -> void:
	if virus_list != Global.store_scenes_as_resources(Global.virus_list ):
		virus_list = Global.store_scenes_as_resources(Global.virus_list)
		update_list(virus_list, "virus")
		
	if bug_list != Global.store_resources(Global.bug_list ):
		bug_list = Global.store_resources(Global.bug_list)
		update_list(bug_list, "bug")
	
	if bug2_list != Global.store_resources(Global.bug2_list ) and bug2_list.size() > 0:
		bug2_list = Global.store_resources(Global.bug2_list)
		update_list(bug2_list, "bug2")
		
	if upgrade_list != Global.store_resources(Global.upgrade_list ):
		upgrade_list = Global.store_resources(Global.upgrade_list)
		update_list(upgrade_list, "upgrade")
	
func add_list_to_inv(sel_list, category: String):
	print("sel: " + str(sel_list) )
	print(list_assign_num(sel_list) )
	var holder = mod_items.get_child(list_assign_num(sel_list) )
	for item in sel_list:
		var stack = false
		var cho = MODIFIER_ITEM.instantiate()
		cho.stats = Global.path_to_resource(category + " choices", item)
		stack = check_duplicates(cho, holder, holder.get_child_count() )
		if not stack:
			holder.add_child(cho )
		cho.get_child(0).modulate = assign_color(sel_list)
	#sel_list.clear()

func add_item_to_inv(item, sel_list, category: String):
	var stack = false
	var cho = MODIFIER_ITEM.instantiate()
	cho.stats = Global.path_to_resource(category + " choices", item)
	stack = check_duplicates(cho, mod_items, mod_items.get_child_count() )
	if not stack:
		mod_items.get_child(list_assign_num(sel_list) ).add_child(cho)
	cho.get_child(0).modulate = assign_color(sel_list)

func update_list(sel_list, category: String ):
	var num = list_assign_num(sel_list)
	for child in mod_items.get_child(num ).get_children():
		print(child.stats)
		child.free()
	add_list_to_inv(sel_list, category)

func assign_color(sel_list):
	if sel_list == virus_list:
		return Color(1, 0.7, 1)
	else: if sel_list == bug_list:
		return Color(1, 0.5, 0.6)
	else: if sel_list == bug2_list:
		return Color(1, 0.6, 0.3)
	else: if sel_list == upgrade_list:
		return Color(0.6, 0.5, 1)

func list_assign_num(sel_list):
	if sel_list == virus_list:
		return 0
	else: if sel_list == bug_list:
		return 1
	else: if sel_list == upgrade_list:
		return 2
	else: if sel_list == bug2_list:
		return 3

func check_duplicates(item, container, count):
	for j in range(count ):
		if container.get_child(j).stats == item.stats:
			container.get_child(j).stack_num += 1
			return true
	return false
