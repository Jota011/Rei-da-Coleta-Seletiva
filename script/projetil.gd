extends Area2D


@export var speed: float = 300.0
@export var trash_type: String = "papel"   # tipo de lixo (definido no Inspector ou na hora de instanciar)


func _process(delta):
	position.y -= speed * delta
	if position.y < -50:
		queue_free()


func _on_body_entered(body):
	if body.is_in_group("trash_bin"):
		if body.bin_type == trash_type:
			print("Acertou a lixeira certa!")
			# Aqui vai o sistema de pontuacao
		else:
			print("Errou a lixeira...")
		queue_free()
