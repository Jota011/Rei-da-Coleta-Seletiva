# MainMenu.gd
extends Control

@onready var start_button: Button = $ColorRect/VBoxContainer/StartButton
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton
@onready var sfx_botao: AudioStreamPlayer2D = $sfx_botao
@onready var sfx_hover: AudioStreamPlayer2D = $sfx_hover

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	start_button.mouse_entered.connect(_on_button_hovered)
	quit_button.mouse_entered.connect(_on_button_hovered)

func _on_button_hovered():
	if not sfx_hover.is_playing():
		sfx_hover.play()

func _on_start_button_pressed():
	sfx_botao.play()
	await sfx_botao.finished 
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_quit_button_pressed():
	sfx_botao.play()
	await sfx_botao.finished
	

	get_tree().quit()
