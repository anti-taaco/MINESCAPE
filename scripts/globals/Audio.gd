extends AudioStreamPlayer2D

@onready var player: Node = $Player
@onready var nyan: Node = $"Nyan Cat"
@onready var sleep : Node = $SleepMode
@onready var bcod: Node = $BCOD
@onready var tetromino: Node = $Tetromino

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for category in get_children():
		for sound in category.get_children():
			sound.bus = bus

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	randomize()

func pause_audio():
	stream_paused = !stream_paused

func stop_audio():
	propagate_call("stop")

# PLAYER AUDIO
func player_open():
	var rand = randf_range(0.8, 1.2)
	player.get_node("Open").set_pitch_scale(rand)
	player.get_node("Open").play()

func player_mine():
	player.get_node("Mine").play()
	
func player_hit():
	player.get_node("Hit").play()
	

# NYAN CAT AUDIO
func nyan_bounce():
	var rand = randf_range(0.9, 1.3)
	nyan.get_node("Bounce").set_pitch_scale(rand)
	nyan.get_node("Bounce").play()


# SLEEPMODE AUDIO
func sleep_active():
	if not sleep.get_node("Active").playing:
		sleep.get_node("Active").play()
func sleep_active_stop():
	sleep.get_node("Active").stop()

func sleep_wake():
	if not sleep.get_node("Wake").playing:
		sleep.get_node("Wake").play()
func sleep_wake_stop():
	sleep.get_node("Wake").stop()

func sleep_hit():
	sleep.get_node("Hit").play()
	

# BCOD AUDIO
func bcod_spin():
	bcod.get_node("Spin").play()

func bcod_spin_stop():
	bcod.get_node("Spin").stop()
	
func bcod_lunge():
	if not bcod.get_node("Lunge").playing:
		bcod.get_node("Lunge").play()


# TETROMINO AUDIO
func tetromino_fall():
	tetromino.get_node("Fall").play()

func tetromino_hit():
	tetromino.get_node("Hit").play()
