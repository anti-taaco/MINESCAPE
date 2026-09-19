extends CanvasLayer

@onready var pause_menu: Control = $"Pause Menu"
@onready var lives_icon: TextureRect = $Lives/IconL

@onready var label_level: Label = $Level/LabelLevel
@onready var label_bits: Label = $Bits/LabelBits
@onready var label_lives: Label = $Lives/LabelL
@onready var label_pos: Label = $LabelPos
@onready var label_mines: Label = $LabelMines
@onready var label_time: Label = $LabelTime
@onready var label_ab_uses: Label = $Ability/LabelAbUses
@onready var label_alt_ab: Label = $AltAb/LabelAltAb

@onready var colorL: ColorRect = $Control/ColorRectL
@onready var colorR: ColorRect = $Control/ColorRectR

@onready var camera: Camera2D = $"../Camera"

const LIVES_3 = preload("uid://cv63rnd56wji8")
const LIVES_2 = preload("uid://dr3wjx7sy3nhk")
const LIVES_1 = preload("uid://bbcj7q4xkhkuy")


var lives
var tile_pos
var mines
var time : float
var ability_uses : int

var game_won

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colorL.size = Vector2(64, 270)
	colorR.size = Vector2(64, 270)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	label_level.text = "LEVEL " + str(Global.level)
	label_pos.text = str(tile_pos)
	label_lives.text = str(lives)
	if lives >= 3:
		lives_icon.texture = LIVES_3
	else: if lives == 2:
		lives_icon.texture = LIVES_2
	else: if lives <= 1:
		lives_icon.texture = LIVES_1
		
	if Modifiers.hide_mines:
		label_mines.text = "???"
	else:
		label_mines.text = digital_num_text(mines)
	label_time.text = digital_num_text(time)
	
	label_ab_uses.text = "USES: " + str(ability_uses)
	if Modifiers.alt_id > 0:
		label_alt_ab.text = "UNLOCKED"
	else:
		label_alt_ab.text = "LOCKED"

func digital_num_text(value: int) -> String:
	var text : String
	if value < 0:
		text = "000"
	else: if value <= 9:
		text = "00" + str(value)
	else: if value <= 99:
		text = "0" + str(value)
	else:
		text = str(value)
	return text
