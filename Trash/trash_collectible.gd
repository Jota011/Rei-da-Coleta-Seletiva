# TrashCollectible.gd
extends Area2D

@export var trash_type: String
@export var texture: Texture

func _ready():
	$Sprite2D.texture = texture
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):  # Adicione o player ao grupo "player" no editor
		body.collect_trash(trash_type, texture)
		queue_free()
