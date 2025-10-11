# Main.gd
extends Node2D

@export var game_over_scene: PackedScene
@export var pause_menu_scene: PackedScene

@onready var player = $Player
@onready var score_label: Label = $ScoreLabel
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel
# --- NOVO: Um array para guardar nossos ícones de vida ---
@onready var life_icons = [$LifeIcon1, $LifeIcon2, $LifeIcon3]

var score = 0
# --- NOVO: Variável para controlar as vidas ---
var lives = 3
# --- NOVO: Flag para garantir que o game over só aconteça uma vez ---
var is_game_over = false

func _ready():
	var lixeiras = get_tree().get_nodes_in_group("lixeiras")
	for lixeira in lixeiras:
		lixeira.trash_collided.connect(_on_trash_collided)
	
	$MissDetector.body_entered.connect(_on_miss_detector_body_entered)
	
	randomize_bin_positions()
	update_score_display()
	# --- NOVO: Atualiza a exibição de vidas no início ---
	update_lives_display()
	timer.start()

func _process(_delta):
	if not is_game_over:
		timer_label.text = "Tempo: " + str(int(ceil(timer.time_left)))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)

func randomize_bin_positions():
	# ... (esta função continua igual)
	var lixeiras = get_tree().get_nodes_in_group("lixeiras")
	if lixeiras.is_empty(): return
	var posicoes_iniciais = []
	for lixeira in lixeiras:
		posicoes_iniciais.append(lixeira.position)
	posicoes_iniciais.shuffle()
	for i in range(lixeiras.size()):
		lixeiras[i].position = posicoes_iniciais[i]


func update_score_display():
	score_label.text = "Score: " + str(score)

# --- NOVO: Função para atualizar os ícones de vida na tela ---
func update_lives_display():
	for i in range(life_icons.size()):
		if i < lives:
			life_icons[i].show() # Mostra o ícone se a vida existir
		else:
			life_icons[i].hide() # Esconde o ícone se a vida foi perdida

func _on_trash_collided(was_correct):
	if was_correct:
		score += 1
		update_score_display()
		player.prepare_next_trash()
	else:
		# Se errou a lixeira, perde uma vida
		lose_life()

func _on_miss_detector_body_entered(body):
	if body.has_method("set_trash_properties"):
		# Se errou tudo (miss detector), perde uma vida
		lose_life()
		body.queue_free()

# --- NOVO: Função central para lidar com a perda de vidas ---
func lose_life():
	lives -= 1
	score -= 1 # Também perde 1 ponto
	update_lives_display()
	update_score_display()
	
	if lives <= 0:
		game_over()
	else:
		# Só prepara o próximo lixo se o jogo não acabou
		player.prepare_next_trash()

func game_over():
	# Se o jogo já acabou (pelo timer ou por vidas), não faz nada
	if is_game_over:
		return
		
	is_game_over = true
	print("Fim de Jogo!")
	get_tree().paused = true
	
	var game_over_instance = game_over_scene.instantiate()
	add_child(game_over_instance)
	game_over_instance.call_deferred("show_final_score", score)

# Conecte o sinal timeout do Timer a esta função no editor
func _on_timer_timeout():
	game_over()
