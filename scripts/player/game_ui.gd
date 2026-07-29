extends CanvasLayer

@onready var pause_menu: Control = $"Pause Menu"

@onready var label_level: Label = $LabelLevel
@onready var label_bits: Label = $LabelBits
@onready var label_lives: Label = $LabelLives
@onready var label_pos: Label = $LabelPos
@onready var label_mines: Label = $LabelMines
@onready var label_time: Label = $LabelTime
@onready var label_ab_uses: Label = $LabelAbUses

@onready var colorL: ColorRect = $Control/ColorRectL
@onready var colorR: ColorRect = $Control/ColorRectR

@onready var camera: Camera2D = $"../Camera"

var lives
var tile_pos
var mines
var time : float
var ability_uses : int

var game_won

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colorL.size = Vector2(104, 270)
	colorR.size = Vector2(104, 270)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	label_level.text = "LEVEL " + str(Global.level)
	label_bits.text = "BITS: " + str(Global.bits)
	label_pos.text = str(tile_pos)
	label_lives.text = "LIVES: " + str(lives)
	if Modifiers.hide_mines:
		label_mines.text = "MINES: n/a"
	else:
		label_mines.text = "MINES: " + str(mines)
	label_time.text = "TIME: " + str(int(time))
	
	label_ab_uses.text = "AB. USES: " + str(ability_uses)
