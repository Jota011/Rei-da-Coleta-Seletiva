extends CharacterBody2D

@export var speed: float = 250
@export var direction: int = 1  # 1 = direita → esquerda, -1 = esquerda → direita

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

func _ready():
	# Escolhe direção aleatória (metade das vezes vem da esquerda)
	if randi() % 2 == 0:
		direction = 1
	else:
		direction = -1

	# Inverte sprite se vier da direita
	if direction == -1:
		scale.x = -1

	# Configura camada de colisão
	# Layer 4 = papagaio
	# Mask 2 = detecta lixo (que está na Layer 2)
	set_collision_layer_value(4, true)
	set_collision_mask_value(2, true)

	# Conecta sinal de colisão
	connect("body_entered", Callable(self, "_on_body_entered"))

	anim.play("fly")

func _physics_process(_delta):
	velocity.x = direction * speed
	move_and_slide()

	# Remove o papagaio se sair da tela
	if global_position.x < -100 or global_position.x > 1000:
		queue_free()

# Detecta colisão com o lixo lançado ou o jogador
func _on_body_entered(body):
	if body == null:
		return

	# --- Se colidir com o lixo lançado ---
	if body.has_method("get_trash_type"):
		print("Papagaio atingido por lixo!")
		body.queue_free() # remove o lixo
		queue_free() # remove o papagaio
		return

	# --- Se colidir com o jogador ---
	if body.name == "Player":
		print("Papagaio colidiu com o jogador!")
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
