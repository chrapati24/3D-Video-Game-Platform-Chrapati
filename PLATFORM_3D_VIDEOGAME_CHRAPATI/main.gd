# Main script. Executed during startup
extends Control

const MAJ_VER: int = 0
const MIN_VER: int = 0
const PATCH_VER: int = 0

var dev_mode = true

func _ready():
	print("Hello, world!")
	print("Copyright (c) 2025 Chrapati. All rights reserved.")
	var error_box_scene = preload("res://assets/ui/error_box.tscn")
	var error_box = error_box_scene.instantiate()
	get_tree().root.add_child(error_box)
	error_box.show_message("An error has occurred.")
	
	
