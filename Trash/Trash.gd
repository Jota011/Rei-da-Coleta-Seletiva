extends CharacterBody2D

# Velocidade com que o lixo sobe (em pixels por segundo)
@export var speed = 1000

var trash_type: String

func _physics_process(delta):
	# Define a velocidade vertical para ser constante e para cima
	# (negativa no eixo Y significa para cima)
	velocity.y = -speed

	# Move o lixo
	move_and_slide()

func set_trash_properties(type: String, texture: Texture):
	self.trash_type = type
	$Sprite2D.texture = texture
