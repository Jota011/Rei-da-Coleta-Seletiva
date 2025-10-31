# papagaio_spawner.gd
extends Node2D

@export var papagaio_scene: PackedScene
@export var spawn_interval: float = 4.0
@export var spawn_y_range: Vector2 = Vector2(100, 400)
@onready var timer: Timer = $Timer

func _ready():
	timer.wait_time = spawn_interval
	timer.start()
	timer.timeout.connect(_on_spawn_timeout)

func _on_spawn_timeout():
	if not papagaio_scene:
		return
	
	var papagaio = papagaio_scene.instantiate()
	
	# Sorteia de qual lado spawnar
	if randf() > 0.5:
		# Spawna da ESQUERDA indo para DIREITA
		papagaio.global_position = Vector2(-100, randf_range(spawn_y_range.x, spawn_y_range.y))
		papagaio.direction = -1  # Vai para direita →
	else:
		# Spawna da DIREITA indo para ESQUERDA
		papagaio.global_position = Vector2(1000, randf_range(spawn_y_range.x, spawn_y_range.y))
		papagaio.direction = 1   # Vai para esquerda ←
	
	get_parent().add_child(papagaio)
