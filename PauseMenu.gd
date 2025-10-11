# PauseMenu.gd
extends CanvasLayer

@onready var resume_button: Button = $ColorRect/VBoxContainer/ResumeButton
@onready var restart_button: Button = $ColorRect/VBoxContainer/RestartButton
# --- NOVO: Referência para o botão de sair ---
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton

func _ready():
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	# --- NOVO: Conecta o sinal do novo botão ---
	quit_button.pressed.connect(_on_quit_button_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_resume_button_pressed()
		get_tree().get_root().set_input_as_handled()

func _on_resume_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# --- NOVO: Função para fechar o jogo ---
func _on_quit_button_pressed():
	get_tree().quit()
