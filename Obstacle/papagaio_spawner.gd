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
	#var spawn_side = randf() > 0.5 ? -100 : 1000
	var spawn_side = -100 if randf() > 0.5 else 1000
	papagaio.global_position = Vector2(spawn_side, randf_range(spawn_y_range.x, spawn_y_range.y))
	get_parent().add_child(papagaio)
