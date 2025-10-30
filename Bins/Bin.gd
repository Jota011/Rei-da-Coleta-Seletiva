extends Area2D

@export var accepts_type: String

signal trash_collided(was_correct: bool)

@onready var sfx_maisponto: AudioStreamPlayer2D = $sfx_maisponto
@onready var sfx_menosponto: AudioStreamPlayer2D = $sfx_menosponto

func _ready():
	# CRÍTICO: Configuração de colisão
	# Layer 0 = lixeira não é um objeto físico
	# Mask Layer 2 = detecta objetos na Layer 2 (lixo lançado)
	set_collision_layer_value(1, false)  # Desliga todas as layers
	set_collision_mask_value(1, false)   # Desliga Mask 1
	set_collision_mask_value(2, true)    # Liga Mask 2 (detecta lixo)
	
	collision_layer = 0
	collision_mask = 2  # Binário: 10 = detecta Layer 2
	
	self.body_entered.connect(_on_body_entered)
	
	print("")
	print("==================================================")
	print("LIXEIRA CRIADA")
	print("Tipo aceito: ", accepts_type)
	print("Posicao X: ", global_position.x)
	print("Posicao Y: ", global_position.y)
	print("Collision Layer: ", collision_layer)
	print("Collision Mask: ", collision_mask)
	print("Detecta Layer 2? ", get_collision_mask_value(2))
	print("==================================================")

func _on_body_entered(body):
	print("")
	print("==================================================")
	print("ALGO COLIDIU COM A LIXEIRA!")
	print("Tipo da lixeira: ", accepts_type)
	print("Nome do corpo: ", body.name)
	print("Collision Layer do corpo: ", body.collision_layer if body.has_method("get_collision_layer") else "N/A")
	print("Tem set_trash_properties? ", body.has_method("set_trash_properties"))
	
	if not body.has_method("set_trash_properties"):
		print("ERRO: Corpo nao tem o metodo set_trash_properties!")
		print("Tipo do objeto: ", body.get_class())
		print("==================================================")
		return
	
	var incoming_type = ""
	if body.has_method("get_trash_type"):
		incoming_type = body.get_trash_type()
		print("Tipo do lixo (via metodo): ", incoming_type)
	else:
		incoming_type = body.trash_type
		print("Tipo do lixo (via variavel): ", incoming_type)
	
	if incoming_type == accepts_type:
		sfx_maisponto.play()
		print(">>> ACERTOU! +1 ponto <<<")
		print("==================================================")
		emit_signal("trash_collided", true)
		
	else:
		print(">>> ERROU! Tipo errado <<<")
		sfx_menosponto.play()
		print("Esperado: ", accepts_type)
		print("Recebido: ", incoming_type)
		print("==================================================")
		emit_signal("trash_collided", false)
	
	body.queue_free()
