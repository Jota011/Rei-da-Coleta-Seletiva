extends CharacterBody2D

@export var speed: float = 250
@export var direction: int = 1  # 1 = direita → esquerda, -1 = esquerda → direita

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

func _ready():
	randomize()
	
	if randi() % 2 == 0:
		direction = 1
	else:
		direction = -1
	
	if direction == -1:
		scale.x = -1
	
	anim.play("fly")

	# Configura camadas de colisão
	# Layer 4 = papagaio, Mask 2 = detecta lixo
	set_collision_layer_value(4, true)
	set_collision_mask_value(2, true)

func _physics_process(delta):
	velocity.x = direction * speed
	move_and_slide()

	if global_position.x < -100 or global_position.x > 1000:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()

	elif body.name == "Trash":
		var main = get_tree().get_current_scene()
		if main.has_method("lose_life"):
			main.lose_life()
		queue_free()
		body.queue_free()
