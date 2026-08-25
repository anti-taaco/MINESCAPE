extends AudioStreamPlayer2D

@export var board: Node
@export var intermission: Node
@export var main_menu: Node
@export var pause: Node

var song
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for category in get_children():
		for sound in category.get_children():
			sound.bus = bus
	
	var playlist = get_tree().get_current_scene().playlist
	if playlist == "Game":
		var rand = randi_range(0, board.get_child_count()-1)
		song = board.get_child(rand)
	elif playlist == "Intermission":
		var rand = randi_range(0, intermission.get_child_count()-1)
		song = intermission.get_child(rand)
	song.play()
	if song == $"Nome da musica?":
		song.seek(10.19)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not song.playing:
		song.play()
