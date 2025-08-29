extends Node2D

var distancia_minima := 120  # distância mínima entre lixeiras

func _ready():
	randomize()
	posicionar_lixeiras_aleatorias()

func posicionar_lixeiras_aleatorias():
	var posicoes_usadas: Array = []

	for lixeira in get_children():
		if lixeira is Area2D:  # só mexe em lixeiras
			var pos = Vector2.ZERO
			var tentativas := 0
			while tentativas < 1000:
				pos.x = randi_range(100, 500)  # ajuste conforme seu mapa
				pos.y = randi_range(200, 400)
				var muito_perto := false
				for p in posicoes_usadas:
					if pos.distance_to(p) < distancia_minima:
						muito_perto = true
						break
				if not muito_perto:
					break
				tentativas += 1
			lixeira.position = pos
			posicoes_usadas.append(pos)
