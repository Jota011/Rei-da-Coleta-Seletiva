extends StaticBody2D


var projectile_scene: PackedScene = preload("res://cenas/player/Projetil/projetil.tscn")


@export var player: bool
@export var velocidade_player: int = 500
@export var shoot_cooldown: float = 0.3     # intervalo entre disparos (segundos)


var can_shoot: bool = true


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	movimento_player(delta)
	limite_mapa()
	if Input.is_action_just_pressed("projetil") and can_shoot:
		shoot()


func movimento_player(delta: float) -> void:
	if Input.is_action_pressed("esquerda"):
		position.x -= velocidade_player * delta
	elif Input.is_action_pressed("direita"):
		position.x += velocidade_player * delta


func limite_mapa() -> void:
	position.x = clamp(position.x, 43, 557)


func shoot():
	var projectile = projectile_scene.instantiate()   # cria o projetil -- Futuramente trocarei essa bomba
	get_parent().add_child(projectile)                # adiciona na main/cena
	projectile.position = position                    # projetil nasce no player
	can_shoot = false
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
