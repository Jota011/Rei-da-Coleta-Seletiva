# MainMenu.gd
extends Control

@onready var start_button: Button = $ColorRect/VBoxContainer/StartButton
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton

func _ready():
	# Conecta o sinal de "pressionado" de cada botão a uma função
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

# Função executada quando o botão "Iniciar Jogo" é pressionado
func _on_start_button_pressed():
	# Pede ao Godot para trocar a cena atual pela cena do jogo
	get_tree().change_scene_to_file("res://Main.tscn")

# Função executada quando o botão "Sair" é pressionado
func _on_quit_button_pressed():
	# Fecha o jogo
	get_tree().quit()
