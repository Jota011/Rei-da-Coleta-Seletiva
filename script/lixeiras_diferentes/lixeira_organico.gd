extends Area2D

@export var bin_type: String = "organico"  # configure no Inspector (papel, plástico, etc.)

func _ready():
	add_to_group("trash_bin")
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D):
	if area.has_method("get_trash_type"):
		var tipo_lixo = area.get_trash_type()

		if tipo_lixo == bin_type:
			print("✅ Acertou! Jogou", tipo_lixo, "na lixeira de", bin_type)
			area.queue_free()  # lixo some
			# aqui soma pontos
		else:
			print("❌ Errou! Jogou", tipo_lixo, "na lixeira de", bin_type)
			area.queue_free()  # lixo também some (ou não, depende da regra)
