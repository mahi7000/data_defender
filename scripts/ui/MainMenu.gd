# scripts/ui/MainMenu.gd
extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var title_label = $TitleLabel

func _ready():
	_apply_cyber_theme()
	start_button.grab_focus()

func _apply_cyber_theme():
	# Style the main menu with cyber theme
	pass

func _on_start_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_quit_button_pressed():
	get_tree().quit()
