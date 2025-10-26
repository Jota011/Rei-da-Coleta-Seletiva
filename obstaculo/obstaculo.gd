extends Area2D

@export var speed := 250.0
@export var horizontal_min := 64
@export var horizontal_max := 1280
@export var vertical_min := 64
@export var vertical_max := 640
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func _ready():
	randomize()

	# Inicia animação
	if anim_sprite:
		anim_sprite.play("voar")  # nome da animação no AnimatedSprite2D

	# Spawn na esquerda ou topo
	var start_side = randi() % 2  # 0 = esquerda, 1 = topo
	if start_side == 0:
		position.x = -50
		position.y = randf_range(vertical_min, vertical_max)
		direction = Vector2(1, randf_range(-0.2, 0.2)).normalized()
	else:
		position.x = randf_range(horizontal_min, horizontal_max)
		position.y = -50
		direction = Vector2(randf_range(-0.2, 0.2), 1).normalized()

	# Conecta sinal de colisão
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))


	print("Papagaio criado em: ", position, " direção: ", direction)

func _process(delta):
	position += direction * speed * delta

	# Remove quando sair da tela completamente
	var screen_size = get_viewport_rect().size
	if position.x < -100 or position.x > screen_size.x + 100 \
	or position.y < -100 or position.y > screen_size.y + 100:
		queue_free()

func _on_body_entered(body):
	# Checa se o corpo é o projetil
	if body.is_in_group("projeteis"):
		body.queue_free()  # remove apenas o projetil
		print("Colisão detectada! Projetil removido.")
