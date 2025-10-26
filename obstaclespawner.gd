extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_interval := 5.0
@onready var timer: Timer = $Timer

func _ready():
	if not timer:
		push_error("❌ Timer não encontrado! Adicione um Timer como filho do ObstacleSpawner.")
		return

	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if obstacle_scene:
		var obstacle = obstacle_scene.instantiate()
		get_parent().add_child(obstacle)
		print("✅ Papagaio criado pelo spawner:", obstacle)
	else:
		push_error("❌ obstacle_scene não definido no Inspector!")
