extends CanvasLayer

@onready var final_score_label: Label = $ColorRect/VBoxContainer/FinalScoreLabel
@onready var retry_button: Button = $ColorRect/VBoxContainer/RetryButton
@onready var quit_button: Button = $ColorRect/VBoxContainer/QuitButton
@onready var sfx_botao: AudioStreamPlayer2D = $sfx_botao

func _ready():
	retry_button.pressed.connect(_on_retry_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func show_final_score(score: int):
	final_score_label.text = "Pontuacao Final: " + str(score)

func _on_retry_button_pressed():
	sfx_botao.play()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	
	get_tree().quit()
