class_name PlayerClass
extends Resource

@export var texture : Texture2D
@export var name : String = "class name"
@export var description : String = "does stuff"

@export_category("Stats")
@export var extra_lives : int = 0
@export var flag_id : int = 0
@export var ability_id : int = 0
@export var alt_ability_id : int = 0

@export_category("Requirements")
@export var unlocked : bool = true


func choose_class():
	pass
