extends Node

@onready var play_btn = $Control/play_btn

# Called when the node enters the scene tree for the first time.
func _ready():
	play_btn.connect("pressed", Callable(self, "_on_play_btn_pressed"))

func _on_play_btn_pressed():
	print("Bouton pressé.")
	get_tree().change_scene_to_file("res://game.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
