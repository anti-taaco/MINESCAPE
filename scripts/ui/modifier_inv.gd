extends Control

@onready var mod_items: GridContainer = $"ScrollContainer/Mod Items"
#@onready var mod_items: GridContainer = $"Mod Items"
@onready var color_rect: ColorRect = $ColorRect
@onready var virus_hold: BoxContainer = $Virus
@onready var bug_hold: BoxContainer = $Bug
@onready var upgrade_hold: BoxContainer = $Upgrade
@onready var bug2_hold: BoxContainer = $Bug2


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
	
	add_list_to_inv(virus_list, virus_hold, "virus")
	add_list_to_inv(bug_list, bug_hold, "bug")
	add_list_to_inv(bug2_list, bug2_hold, "bug2")
	add_list_to_inv(upgrade_list, upgrade_hold, "upgrade")


# FIX MOVING DOWN ISSUE
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("check modifiers"):
		visible = !visible
	
	var replace = false
	if virus_list != Global.store_scenes_as_resources(Global.virus_list ):
		virus_list = Global.store_scenes_as_resources(Global.virus_list)
		replace = true
		
		
	if bug_list != Global.store_resources(Global.bug_list ):
		bug_list = Global.store_resources(Global.bug_list)
		replace = true
		
	
	if bug2_list != Global.store_resources(Global.bug2_list ) and bug2_list.size() > 0:
		bug2_list = Global.store_resources(Global.bug2_list)
		replace = true
		
		
	if upgrade_list != Global.store_resources(Global.upgrade_list ):
		upgrade_list = Global.store_resources(Global.upgrade_list)
		replace = true
		
	
	if replace:
		for child in mod_items.get_children():
			mod_items.remove_child(child )
		update_list(virus_list, virus_hold, "virus")
		update_list(bug_list, bug_hold, "bug")
		update_list(bug2_list, bug2_hold, "bug2")
		update_list(upgrade_list, upgrade_hold, "upgrade")
	
func add_list_to_inv(sel_list, holder, category: String):
	print("sel: " + str(sel_list) )
	print(list_assign_num(sel_list) )
	for item in sel_list:
		var stack = false
		var cho = MODIFIER_ITEM.instantiate()
		cho.stats = Global.path_to_resource(category + " choices", item)
		stack = check_duplicates(cho, holder, holder.get_child_count() )
		if not stack:
			holder.add_child(cho )
		cho.get_child(0).modulate = assign_color(sel_list)
	add_to_grid(holder)
		
#func add_list_to_inv(sel_list, category: String):
	#print("sel: " + str(sel_list) )
	#print(list_assign_num(sel_list) )
	#var holder = mod_items.get_child(list_assign_num(sel_list) )
	#for item in sel_list:
		#var stack = false
		#var cho = MODIFIER_ITEM.instantiate()
		#cho.stats = Global.path_to_resource(category + " choices", item)
		#stack = check_duplicates(cho, holder, holder.get_child_count() )
		#if not stack:
			#holder.add_child(cho )
		#cho.get_child(0).modulate = assign_color(sel_list)

func add_item_to_inv(item, sel_list, category: String):
	var stack = false
	var cho = MODIFIER_ITEM.instantiate()
	cho.stats = Global.path_to_resource(category + " choices", item)
	stack = check_duplicates(cho, mod_items, mod_items.get_child_count() )
	if not stack:
		mod_items.get_child(list_assign_num(sel_list) ).add_child(cho)
	cho.get_child(0).modulate = assign_color(sel_list)

func update_list(sel_list, holder, category: String ):
	var num = list_assign_num(sel_list)
	print("hold:" + str(holder) )
	for child in holder.get_children(): #mod_items.get_child(num ).get_children():
		print(child.stats)
		child.free()
	add_list_to_inv(sel_list, holder, category)

func add_to_grid(holder):
	for child in holder.get_children():
		holder.remove_child(child )
		mod_items.add_child(child )

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
