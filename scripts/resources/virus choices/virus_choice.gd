class_name VirusChoice
extends Resource

@export var texture : Texture2D
@export var name : String = "virus name"
@export var description : String = "does stuff"
@export var bit_gain : int = 100
@export var stack : int = 0

@export_category("Requirements")
@export var level : int = 0
@export var can_choose : bool = true

func change_stats():
	pass

func add_virus():
	var virus_name = str(resource_path.get_file().get_basename() ) + str(".tscn")
	Global.virus_list.append(virus_name)

func add_temp_virus():
	var virus_name = str(resource_path.get_file().get_basename() ) + str(".tscn")
	Global.temp_viruses.append(virus_name)

func count_amount():
	return Global.count_amount(Global.virus_list, resource_path.get_file().get_basename())
