extends Node3D

@onready var debug_ui = $ui_debug
@onready var player = $player/CharacterBody3D

@onready var camera1 = $Camera3D
@onready var camera2 = $Camera3DTop
@onready var camera3 = $player/CharacterBody3D/CameraPivot/SpringArm3D/TPSCamera

@onready var death_screen_scene = preload("res://scenes/ui/death_screen.tscn")
@onready var pause_screen_scene = preload("res://scenes/ui/pause_screen.tscn")

var death_screen
var pause_screen
var current_camera = 0

func _ready():
	death_screen = death_screen_scene.instantiate()
	add_child(death_screen)
	
	pause_screen = pause_screen_scene.instantiate()
	add_child(pause_screen)
	
	print("Hello, world!")
	print("Death screen ID : ", death_screen, ", Pause screen ID : ", pause_screen)
	
	death_screen.hide_death_screen()
	pause_screen.hide_pause_screen()
	
	debug_ui.player_node = player
	
	camera1.current = false
	camera2.current = false
	camera3.current = false
	
	camera3.current = true
	current_camera = 3
	
	player.died.connect(on_player_died)
	player.pause_game.connect(on_player_paused_game)
	
	death_screen.restart_requested.connect(_on_restart)
	death_screen.quit_requested.connect(_on_quit)
	
	pause_screen.resume_requested.connect(_on_resume)
	pause_screen.credits_requested.connect(_on_credits)
	pause_screen.quit_requested.connect(_on_quit)
	pause_screen.back_pause_requested.connect(_on_back_pause)

func _process(delta):
	if Input.is_action_just_pressed("ui_switch_right_gamepad"):
		print("Hello, world!")
		toggle_cameras()

# Multiple cameras on the scene
func toggle_cameras():
	camera1.current = false
	camera2.current = false
	camera3.current = false
	
	current_camera += 1
	if current_camera > 3:
		current_camera = 1
	
	match current_camera:
		1:
			camera1.current = true
		2:
			camera2.current = true
		3:
			camera3.current = true

func on_player_died():
	get_tree().paused = true
	death_screen.show_screen()

func on_player_paused_game():
	get_tree().paused = true
	pause_screen.show_pause_screen()

func _on_restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_resume():
	get_tree().paused = false
	pause_screen.hide_pause_screen()

func _on_credits():
	pause_screen.show_pause_credits()

func _on_quit():
	get_tree().quit()

func _on_back_pause():
	pause_screen.hide_pause_credits()
