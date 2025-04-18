extends Control

signal resume_requested
signal credits_requested
signal quit_requested

signal back_pause_requested

# Main Menu
@onready var resume_btn = $CanvasLayer/MainPauseMenu/VBoxContainerMain/VBoxContainerBtn/resume_btn
@onready var quit_btn = $CanvasLayer/MainPauseMenu/VBoxContainerMain/VBoxContainerBtn/quit_btn
@onready var credits_btn = $CanvasLayer/MainPauseMenu/VBoxContainerMain/VBoxContainerBtn/credits_btn

# Credits
@onready var back_pause_btn = $CanvasLayer/CreditsPauseMenu/VBoxContainer/HBoxContainer/back_pause_btn

@onready var main_menu = $CanvasLayer/MainPauseMenu
@onready var credits_menu = $CanvasLayer/CreditsPauseMenu

func _ready():
	# Main Menu
	resume_btn.pressed.connect(emit_resume)
	credits_btn.pressed.connect(emit_credits)
	quit_btn.pressed.connect(emit_quit)
	hide_pause_screen()

func show_pause_screen():
	$CanvasLayer.visible = true
	hide_pause_credits()
	await get_tree().process_frame
	resume_btn.grab_focus()

func show_pause_credits():
	main_menu.visible = false
	credits_menu.visible = true
	back_pause_btn.pressed.connect(emit_back_pause)
	back_pause_btn.grab_focus()

func hide_pause_screen():
	$CanvasLayer.visible = false

func hide_pause_credits():
	main_menu.visible = true
	credits_menu.visible = false
	credits_btn.grab_focus()

func emit_resume():
	resume_requested.emit()

func emit_credits():
	$UISelectSound.play()
	credits_requested.emit()

func emit_quit():
	$UISelectSound.play()
	quit_requested.emit()

func emit_back_pause():
	back_pause_requested.emit()
