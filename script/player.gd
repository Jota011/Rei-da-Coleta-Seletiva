extends StaticBody2D


@export var player : bool
var velocidade_player : int = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movimento_player(delta)


func movimento_player(delta: float) -> void:
	if Input.is_action_pressed("esquerda"):
		position.x -= velocidade_player * delta
	elif Input.is_action_pressed("direita"):
		position.x += velocidade_player * delta
