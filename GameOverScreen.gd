# GameOverScreen.gd
extends CanvasLayer

@onready var final_score_label: Label = $ColorRect/VBoxContainer/FinalScoreLabel # Ajuste o caminho se necessário
@onready var retry_button: Button = $ColorRect/VBoxContainer/RetryButton # Ajuste o caminho se necessário
# --- NOVO: Referência para o botão de sair ---
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton # Ajuste o caminho se necessário

func _ready():
	retry_button.pressed.connect(_on_retry_button_pressed)
	# --- NOVO: Conecta o sinal do novo botão ---
	quit_button.pressed.connect(_on_quit_button_pressed)

func show_final_score(score: int):
	final_score_label.text = "Pontuação Final: " + str(score)

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# --- NOVO: Função para fechar o jogo ---
func _on_quit_button_pressed():
	get_tree().quit()
