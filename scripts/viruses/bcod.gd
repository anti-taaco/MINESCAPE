class_name BCOD
extends CharacterBody2D

var player : Node2D
var cursor : Node2D
@onready var sprite: Sprite2D = $Sprite2D

var angle : float = 0
var spin_speed : float = 15
var offset : Vector2
var volley_current : int = 0
var volley_amount : int = 1
var line_amount : int = 3 + Modifiers.bcod_additional_lines

var time : Array = [0,0,0,0]
var spawn_time : float
var spin_duration : float = 300
var stop_duration : float = 35 * Modifiers.bcod_stop_multiplier
var lunge_duration : float = 20
var active = false
var following = false
var firing = false

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	cursor = Global.find_node_in_parent(player, "Cursor")
	randomize_spawn_time()

func _physics_process(delta: float) -> void:
	if time[0] > spawn_time * delta:
		if not active:
			following = true
			for i in range(line_amount):
				var line = load("res://scenes/viruses/parts/bcod_line.tscn")
				$Lines.add_child(line.instantiate() )
			randomize_lines()
		active = true
	else: if not player.invincible:
		time[0] += delta
	
	if active:
		Audio.bcod_spin()
		sprite.visible = true
		if not firing:
			for line in $Lines.get_children():
				line.angle += spin_speed * delta
				line.offset = Vector2(cos(line.angle), sin(line.angle)) * -2.15
				line.global_position = global_position + offset
				line.rotation = line.angle
		if time[1] > spin_duration * delta:
			Audio.bcod_spin_stop()
			firing = true
		else:
			time[1] += delta
	else:
		sprite.visible = false
	
	if following:
		global_position = cursor.mouse_pos
	
	if firing:
		if time[2] > stop_duration * delta:
			following = false
			if time[3] > lunge_duration * delta:
				randomize_spawn_time()
				firing = false
				time = [0,0,0,0]
				volley_current += 1
				if volley_current >= volley_amount:
					active = false
					for line in $Lines.get_children():
						line.queue_free()
					volley_current = 0
				else:
					randomize_lines()
					following = true
			else:
				if time[3] > lunge_duration/2.0 * delta:
					Audio.bcod_lunge()
					for line in $Lines.get_children():
						line.global_position += line.offset * 1.5
				time[3] += delta
		else:
			time[2] += delta
		
func randomize_spawn_time():
	spawn_time = Global.favorable_rng(300, 540, Modifiers.luck_factor, 2, 2)
	spin_speed = Global.favorable_rng(9, 16, Modifiers.luck_factor, 1, 2)
	spin_duration = randi_range(75, 125)

func randomize_lines():
	var i = 0
	while i < $Lines.get_child_count():
		print(i)
		var line = $Lines.get_child(i)
		line.randomize_line()
		var reroll = false
		for j in range($Lines.get_child_count() ):
			var compare = $Lines.get_child(j)
			print(compare.angle)
			if i != j and (line.angle <= compare.angle+0.5 and line.angle >= compare.angle-0.5):
				print("same")
				reroll = true
		if not reroll:
			i += 1
