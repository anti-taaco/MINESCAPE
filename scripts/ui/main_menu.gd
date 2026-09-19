extends Node2D

var playlist = "Intermission"
var instant_play = true
var can_play = true

@onready var tips_page: Control = $"Tips Page"
@onready var volume: HSlider = $"Volume Slider"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume.value = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(0, volume.value)
	print(volume.value)

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/game/intermission.tscn")

func _on_quit_button_up() -> void:
	get_tree().quit()

func _on_tips_button_up() -> void:
	tips_page.visible = !tips_page.visible
