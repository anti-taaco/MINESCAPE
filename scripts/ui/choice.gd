class_name Choice
extends Control

@onready var name_label: Label = $Name_Label
@onready var texture: TextureRect = $TextureRect
@onready var button: Button = $Button
@onready var tooltip: PanelContainer = $TextureRect/Tooltip

@export var stats : Resource
var intermission

var description : String
var bit_str : String
var bit_calc : int
var bit_mult : float = 1
var count : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intermission = get_tree().get_current_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stats:
		name_label.text = stats.name
		texture.texture = stats.texture
		tooltip.text = stats.description
		stats.change_stats()
		count = stats.count_amount()
	if stats is UpgradeChoice:
		bit_calc = -int(stats.bit_cost)
		bit_str = str(bit_calc)
		if Global.bits < stats.bit_cost:
			button.add_theme_color_override("font_color", Color(1, 0, 0))
		else:
			button.add_theme_color_override("font_color", Color.WHITE)
	else:
		bit_calc = int(stats.bit_gain * Modifiers.bit_gain_multiplier)
		bit_str = "+" + str(bit_calc)
	button.text = bit_str + " BITS"

func _on_button_button_up() -> void:
	if stats is VirusChoice and intermission.viruses > 0:
		stats.add_virus()
		intermission.viruses -= 1
		print("virused")
	elif stats is BugChoice and intermission.bugs > 0:
		stats.apply_bug()
		var bug_name = str(stats.resource_path.get_file().get_basename() ) + str(".tres")
		Global.bug_list.append(bug_name)
		#Global.bug_list.append(stats.resource_path)
		intermission.bugs -= 1
		print("bugged")
	elif stats is Bug2Choice and intermission.bugs_squared > 0:
		stats.apply_bug2()
		var bug2_name = str(stats.resource_path.get_file().get_basename() ) + str(".tres")
		Global.bug2_list.append(bug2_name)
		#Global.bug2_list.append(stats.resource_path)
		intermission.bugs_squared -= 1
		print("bugged2")
	if stats is UpgradeChoice and Global.bits >= stats.bit_cost:
		stats.apply_upgrade()
		var upgrade_name = str(stats.resource_path.get_file().get_basename() ) + str(".tres")
		Global.upgrade_list.append(upgrade_name)
		print("upgraded")
	
	intermission.breakout = true
	if stats is not UpgradeChoice:
		Global.bits += bit_calc
	else:
		if Global.bits >= -bit_calc:
			Global.bits += bit_calc
		var regex = RegEx.new()
		regex.compile("\\d+")
		var result = regex.search(str(self) )
		intermission.last_chosen = result.get_string().to_int() -1


func _on_texture_rect_mouse_exited() -> void:
	pass # Replace with function body.
