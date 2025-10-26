# TrashSpawner.gd
extends Node2D

@export var trash_scene: PackedScene  # arraste TrashCollectible.tscn aqui
@export var spawn_area: Rect2 = Rect2(Vector2(100, 600), Vector2(800, 80)) # área de spawn no chão
@export var spawn_interval: float = 3.0  # intervalo em segundos

func _ready():
	randomize()
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_spawn_timeout)
	add_child(timer)

func _on_spawn_timeout():
	if not trash_scene:
		push_error("❌ Nenhuma cena atribuída ao TrashSpawner. Arraste TrashCollectible.tscn no Inspetor!")
		return

	var trash_instance = trash_scene.instantiate()
	var x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	trash_instance.global_position = Vector2(x, y)
	get_tree().current_scene.add_child(trash_instance)
