extends Area2D

@export var speed: float = 300.0
@export var trash_type: String = "papel"   # configure no Inspector

func get_trash_type() -> String:
	return trash_type

func _process(delta):
	position.y -= speed * delta
