extends Node2D

@export var speed: float = 300.0
@export var trash_type: String = "papel"

func get_trash_type():
	return trash_type

func _process(delta):
	position.y -= speed * delta
	if position.y < -50:
		queue_free()

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if area.is_in_group("trash_bin"):
		if area.get("bin_type") == trash_type:
			print("✅ Acertou a lixeira certa!")
			# Aqui você pode adicionar pontos
		else:
			print("❌ Errou a lixeira...")
		queue_free()
