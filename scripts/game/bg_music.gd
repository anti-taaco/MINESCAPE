extends AudioStreamPlayer2D

@onready var board: Node = $Board
@onready var intermission: Node = $Intermission
@onready var main_menu: Node
@onready var pause: Node
@onready var game_over: Node = $"Game Over"

var song
var playlist
var instant_play : bool
var can_play : bool = true
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for category in get_children():
		for sound in category.get_children():
			sound.bus = bus
	
	playlist = get_tree().get_current_scene().playlist
	instant_play = get_tree().get_current_scene().instant_play
	if playlist == "Game":
		var rand = randi_range(0, board.get_child_count()-1)
		song = board.get_child(rand)
	elif playlist == "Intermission":
		var rand = randi_range(0, intermission.get_child_count()-1)
		song = intermission.get_child(rand)
	elif playlist == "Game Over":
		var rand = randi_range(0, game_over.get_child_count()-1)
		song = game_over.get_child(rand)
	if instant_play:
		song.play()
	if song == $"Board/Nome da musica?":
		song.seek(10.19)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	can_play = get_tree().get_current_scene().can_play
	if not song.playing and can_play:
		song.play()
