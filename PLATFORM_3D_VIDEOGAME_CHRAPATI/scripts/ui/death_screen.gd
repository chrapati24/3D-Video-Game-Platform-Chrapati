extends Control

signal restart_requested
signal quit_requested

@onready var yes_btn = $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/yes_btn
@onready var no_btn = $CanvasLayer/CenterContainer/VBoxContainer/HBoxContainer/no_btn

func _ready():
	yes_btn.pressed.connect(emit_restart)
	no_btn.pressed.connect(emit_quit)
	hide_death_screen()

func show_screen():
	$CanvasLayer.visible = true
	await get_tree().process_frame
	yes_btn.grab_focus()

func hide_death_screen():
	$CanvasLayer.visible = false

func emit_restart():
	restart_requested.emit()

func emit_quit():
	quit_requested.emit()
