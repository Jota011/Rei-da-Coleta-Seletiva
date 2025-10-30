extends CharacterBody2D

@export var speed = 1000

var trash_type: String
var is_collectable = false
var is_launched = false
var sprite: Sprite2D

@onready var sfx_coleta: AudioStreamPlayer2D = $sfx_coleta

func _ready():
	print("")
	print("Trash instanciado")
	
	sprite = get_node_or_null("Sprite2D")
	
	if not sprite:
		print("ERRO: Sprite2D nao encontrado!")
	else:
		print("Sprite2D encontrado")
	
	z_index = 1
	
	print("Posicao X: ", global_position.x)
	print("Posicao Y: ", global_position.y)
	print("is_collectable: ", is_collectable)
	print("is_launched: ", is_launched)

func _physics_process(_delta):
	if is_launched:
		velocity.y = -speed
		move_and_slide()
		
		if global_position.y < -100:
			print("Lixo saiu da tela - removendo")
			queue_free()

func set_collectable_trash(type: String, texture: Texture):
	print("")
	print("Configurando lixo COLETAVEL...")
	
	trash_type = type
	is_collectable = true
	is_launched = false
	
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	
	if sprite:
		sprite.texture = texture
		sprite.scale = Vector2(0.3, 0.3)
		print("Textura aplicada: ", type)
	else:
		print("ERRO: Sprite2D e null!")
	
	add_to_group("collectable_trash")
	
	# Lixo coletável não tem colisão
	collision_layer = 0
	collision_mask = 0
	
	print("Collision Layer (coletavel): ", collision_layer)
	print("Collision Mask (coletavel): ", collision_mask)

func set_launched_trash(type: String, texture: Texture, sprite_scale: Vector2):
	print("")
	print("Configurando lixo LANCADO...")
	
	trash_type = type
	is_collectable = false
	is_launched = true
	
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	
	if sprite:
		sprite.texture = texture
		sprite.scale = sprite_scale
		print("Lixo lancado: ", type)
		print("trash_type definido: ", trash_type)
	else:
		print("ERRO: Sprite2D e null!")
	
	if is_in_group("collectable_trash"):
		remove_from_group("collectable_trash")
	
	# CRÍTICO: Configuração de colisão para lixo lançado
	# Layer 2 = onde o lixo "existe"
	# Mask 0 = lixo não detecta nada (as lixeiras é que detectam o lixo)
	# Lixo lançado (projétil)
# Layer 2 = lixo
# Mask 4 = detecta papagaio
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)
	set_collision_layer_value(4, false)

	collision_layer = 2
	collision_mask = 4  # agora o lixo detecta papagaios

	
	print("Collision Layer (lancado): ", collision_layer)
	print("Collision Mask (lancado): ", collision_mask)

func set_trash_properties(type: String, texture: Texture, sprite_scale: Vector2):
	set_launched_trash(type, texture, sprite_scale)

func get_trash_type() -> String:
	return trash_type
