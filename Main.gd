extends Node2D

@export var game_over_scene: PackedScene
@export var pause_menu_scene: PackedScene

@onready var player = $Player
@onready var score_label: Label = $ScoreLabel
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel
@onready var life_icons = [$LifeIcon1, $LifeIcon2, $LifeIcon3]
@onready var sfx_miss: AudioStreamPlayer2D = $sfx_miss

var score = 0
var lives = 3
var is_game_over = false

func _ready():
	# CRÍTICO: Adiciona este nó ao grupo para que o Papagaio possa encontrá-lo.
	add_to_group("main_game_manager")
	
	var lixeiras = get_tree().get_nodes_in_group("lixeiras")
	for lixeira in lixeiras:
		lixeira.trash_collided.connect(_on_trash_collided)
	
	$MissDetector.body_entered.connect(_on_miss_detector_body_entered)
	
	randomize_bin_positions()
	update_score_display()
	update_lives_display()
	timer.start()

func _process(_delta):
	if not is_game_over:
		timer_label.text = "Tempo: " + str(int(ceil(timer.time_left)))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		# CRÍTICO: Não use queue_free() ou get_tree().paused = true aqui!
		# Você deve apenas instanciar o menu de pausa e DEIXAR O SCRIPT dele
		# gerenciar o 'get_tree().paused = true' para garantir que os botões funcionem.
		if not get_tree().paused: # Verifica se já não está pausado
			get_tree().paused = true
			var pause_menu_instance = pause_menu_scene.instantiate()
			add_child(pause_menu_instance)

func randomize_bin_positions():
	var lixeiras = get_tree().get_nodes_in_group("lixeiras")
	if lixeiras.is_empty(): 
		return
	
	var posicoes_iniciais = []
	for lixeira in lixeiras:
		posicoes_iniciais.append(lixeira.position)
	
	posicoes_iniciais.shuffle()
	
	for i in range(lixeiras.size()):
		lixeiras[i].position = posicoes_iniciais[i]

func update_score_display():
	score_label.text = "Score: " + str(score)

func update_lives_display():
	for i in range(life_icons.size()):
		if i < lives:
			life_icons[i].show()
		else:
			life_icons[i].hide()

func _on_trash_collided(was_correct):
	if was_correct:
		score += 1
		update_score_display()
	else:
		# Penalidade para lixo errado é tratada em lose_life()
		lose_life()

func _on_miss_detector_body_entered(body):
	sfx_miss.play()
	if body.has_method("set_trash_properties"):
		lose_life()
		body.queue_free()

# --- FUNÇÃO CHAMADA PELO PAPAGAIO PARA PERDER VIDA/PONTOS ---
func on_player_hit():
	# Esta função é chamada quando o Papagaio atinge o Player
	print("LOG DANO: Player atingido por Papagaio! Perde vida e score.")
	
	# 1. Perde 1 de vida (coração)
	lives -= 1
	
	# 2. Perde 1 de score (ponto)
	score -= 1
	if score < 0:
		score = 0 # Garante que a pontuação não fica negativa se for a regra

	update_lives_display()
	update_score_display()
	
	if lives <= 0:
		game_over()

func lose_life():
	# Esta função será chamada por _on_trash_collided ou _on_miss_detector_body_entered
	lives -= 1
	
	# Corrigido: Garante que a pontuação é subtraída AQUI se o lixo errado/miss for a penalidade
	score -= 1
	if score < 0:
		score = 0
		
	update_lives_display()
	update_score_display()
	
	if lives <= 0:
		game_over()

func game_over():
	if is_game_over:
		return
	
	is_game_over = true
	print("Fim de Jogo!")
	get_tree().paused = true
	
	var game_over_instance = game_over_scene.instantiate()
	add_child(game_over_instance)
	game_over_instance.call_deferred("show_final_score", score)

func _on_timer_timeout():
	game_over()

# Mantida para compatibilidade, mas agora usa a lógica consolidada
func decrease_life(amount: int = 1):
	# Nota: O 'amount' não é usado, mas mantido para evitar erros em outros scripts.
	lose_life()

func decrease_score(amount: int = 1):
	score -= amount
	update_score_display()
