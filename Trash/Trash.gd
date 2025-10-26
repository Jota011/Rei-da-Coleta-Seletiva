 # Trash.gd
extends CharacterBody2D

@export var speed = 1000
var trash_type: String

func _physics_process(_delta):
	velocity.y = -speed
	move_and_slide()

	# Se sair da tela, é removido
	if global_position.y < -50:
		queue_free()

func set_trash_properties(type: String, texture: Texture):
	trash_type = type
	$Sprite2D.texture = texture
