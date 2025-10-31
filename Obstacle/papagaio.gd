extends CharacterBody2D

@export var speed: float = 250
@export var direction: int = 1  # 1 = direita → esquerda, -1 = esquerda → direita

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

func _ready():
	if randi() % 2 == 0:
		direction = 1
	else:
		direction = -1

	if direction == -1:
		scale.x = -1

	anim.play("fly")

	# Garante a configuração correta das Layers/Masks (idealmente no Editor, mas aqui como fallback)
	# Papagaio está na Layer 4. Detecta Lixo (Mask 2) e Player (Mask 1).
	set_collision_layer_value(4, true)
	set_collision_mask_value(1, true)   
	set_collision_mask_value(2, true)   

func _physics_process(_delta):
	velocity.x = direction * speed
	move_and_slide()

	# --- Tratamento de Colisão (CORRIGIDO) ---
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var body = c.get_collider()
		
		# 1. Colisão com o Lixo (Projétil)
		if body.is_in_group("launched_trash"): 
			on_hit_by_trash()
			# CRÍTICO: Destrói o projétil para não causar o "empurrão"
			if is_instance_valid(body):
				body.queue_free()
			
			queue_free() # Papagaio desaparece
			return
		
		# 2. Colisão com o Player: Ação de Dano
		elif body.name == "Player":
			print("LOG: COLISÃO DETECTADA: Papagaio atingiu o Player! Aplicando dano.")
			
			# CRÍTICO: Busca o nó Main com o grupo CORRETO
			var main_node = get_tree().get_first_node_in_group("main_game_manager")
			
			if main_node and main_node.has_method("on_player_hit"):
				main_node.on_player_hit() # CHAMA A FUNÇÃO DE DANO NO MAIN
			
			queue_free() # Papagaio desaparece
			return

	# Saiu da tela? Destrói
	if global_position.x < -200 or global_position.x > 1200:
		queue_free()

func on_hit_by_trash():
	print("Papagaio atingido pelo lixo! - Destruído.")
	# Se quiser adicionar pontuação aqui, adicione a lógica (e.g., emitir sinal para o Main)
