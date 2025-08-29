extends Area2D

@export var speed: float = 300.0
@export var trash_type: String = "metal"   # pode configurar no Inspector

func get_trash_type() -> String:
	return trash_type

func _process(delta):
	# Movimento simples (sobe pra cima)
	position.y -= speed * delta
	
