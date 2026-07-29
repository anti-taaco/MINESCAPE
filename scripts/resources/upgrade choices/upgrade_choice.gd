class_name UpgradeChoice
extends Resource

@export var texture : Texture2D
@export var name : String = "upgrade name"
@export var description : String = "does stuff"
@export var bit_cost : int = 100
@export var stack : int = 0

@export_category("Requirements")
@export var level : int = 0
@export var virus_needed : Array[String]
@export var can_choose : bool = true

func change_stats():
	pass

func apply_upgrade():
	pass

func count_amount():
	return Global.count_amount(Global.upgrade_list, resource_path.get_file().get_basename())
