extends Node2D

@onready var game_screen: TextureRect = $TextureRect
@onready var color_rect: ColorRect = $ColorRect
@onready var music: AudioStreamPlayer2D = $"BG Music"

var sent : bool = false

var playlist = "Game Over"
var instant_play : bool = false
var can_play : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.stop_audio()
	game_screen.texture = Global.screenshot
	color_rect.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(3).timeout
	if color_rect.modulate.a < 0.5:
		color_rect.modulate.a += 0.025
	await get_tree().create_timer(4).timeout
	if not sent:
		popup_message()

func popup_message():
	$AcceptDialog.dialog_text = "ERROR 001: YOU FUCKING DIED."
	$AcceptDialog.popup_centered()

func _on_accept_dialog_confirmed() -> void:
	can_play = true
	sent = true
