extends Control

@onready var error_label = $Panel/VBoxContainer/error_label
@onready var error_ok = $Panel/VBoxContainer/error_ok

func _ready():
	print($Panel)
	error_ok.pressed.connect(_on_ok_pressed)
	hide()

func show_message(string):
	error_label.text = string
	show()
	grab_focus()
	error_ok.grab_focus()

func _on_ok_pressed():
	hide()
