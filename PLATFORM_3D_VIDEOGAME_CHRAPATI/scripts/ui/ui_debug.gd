extends Control

@onready var position_label = $player_pos_label
var player_node : CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("UI debug initialized.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position_label.text = "Coucou debug"
	if player_node:
		var pos = player_node.global_position
		position_label.text = "Player: (%.2f, %.2f, %.2f)" % [pos.x, pos.y, pos.z]
