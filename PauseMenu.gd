extends CanvasLayer

@onready var resume_button: Button = $ColorRect/VBoxContainer/ResumeButton
@onready var restart_button: Button = $ColorRect/VBoxContainer/RestartButton
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton
@onready var sfx_botao: AudioStreamPlayer2D = $sfx_botao
@onready var sfx_hover: AudioStreamPlayer2D = $sfx_hover

func _ready():
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	resume_button.mouse_entered.connect(_on_button_hovered)
	restart_button.mouse_entered.connect(_on_button_hovered)
	quit_button.mouse_entered.connect(_on_button_hovered)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_resume_button_pressed()
		get_tree().get_root().set_input_as_handled()

# 3. NOVO: Função para o áudio de HOVER
func _on_button_hovered():
	# Toca o som de hover, mas só se ele ainda não estiver tocando.
	if not sfx_hover.is_playing():
		sfx_hover.play()

func _on_resume_button_pressed():
	sfx_botao.play()
	# Espera o som terminar antes de fechar o menu
	await sfx_botao.finished 
	
	get_tree().paused = false
	queue_free()

func _on_restart_button_pressed():
	sfx_botao.play()
	# Espera o som terminar antes de recarregar a cena
	await sfx_botao.finished 
	
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	sfx_botao.play()
	# Espera o som terminar antes de fechar o jogo
	await sfx_botao.finished 
	
	get_tree().quit()
