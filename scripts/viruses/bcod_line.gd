extends Line2D

var player : Node2D
var bcod : CharacterBody2D

var angle : float
var speed : float = 10
var offset : Vector2

func _ready():
	player = Global.find_node_in_scene(self, "Player")
	bcod = get_parent().get_parent()

func _physics_process(delta: float) -> void:
	pass

func randomize_line():
	angle = deg_to_rad(randf_range(0, 360) )

func _on_area_2d_mouse_entered() -> void:
	if bcod.firing:
		print("BCOD hit")
		player.take_damage(1, bcod.get_node("Sprite2D").texture )
