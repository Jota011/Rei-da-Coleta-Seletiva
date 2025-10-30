extends Node2D

@export var spawn_distance: float = 200.0
@export var spawn_min_x: float = 100.0
@export var spawn_max_x: float = 700.0

var player: CharacterBody2D
var trash_scene: PackedScene

var trash_textures = {
	"metal": preload("res://assets/metal_p.png"),
	"organico": preload("res://assets/organico_p.png"),
	"papel": preload("res://assets/papel_p.png"),
	"plastico": preload("res://assets/plastico_p.png"),
	"vidro": preload("res://assets/vidro_p.png")
}

var trash_keys = trash_textures.keys()
var can_spawn = true

func _ready():
	player = get_parent().get_node_or_null("Player")
	trash_scene = load("res://Trash/Trash.tscn")
	
	print("==================================================")
	print("VERIFICANDO TRASHSPAWNER...")
	
	if player:
		print("Player encontrado: ", player.name)
		print("Posicao do Player X: ", player.global_position.x)
		print("Posicao do Player Y: ", player.global_position.y)
		
		if not player.trash_collected.is_connected(_on_trash_collected):
			player.trash_collected.connect(_on_trash_collected)
			print("Sinal trash_collected conectado")
		
		if not player.trash_launched.is_connected(_on_trash_launched):
			player.trash_launched.connect(_on_trash_launched)
			print("Sinal trash_launched conectado")
	else:
		print("ERRO: Player NAO encontrado!")
		return
	
	if trash_scene:
		print("Trash.tscn carregado com sucesso")
	else:
		print("ERRO ao carregar Trash.tscn")
		return
	
	print("==================================================")
	
	await get_tree().process_frame
	spawn_trash()

func spawn_trash():
	print("")
	print("Tentando spawnar lixo...")
	print("can_spawn = ", can_spawn)
	
	if not can_spawn:
		print("Spawn bloqueado - aguardando player pegar e lancar")
		return
	
	if not trash_scene:
		print("ERRO: trash_scene e null!")
		return
	
	if not player:
		print("ERRO: player e null!")
		return
	
	var random_type = trash_keys[randi() % trash_keys.size()]
	var random_texture = trash_textures[random_type]
	
	var trash_instance = trash_scene.instantiate()
	
	if not trash_instance:
		print("ERRO: Falha ao instanciar trash!")
		return
	
	var spawn_side = randi() % 2
	var spawn_x: float
	
	if spawn_side == 0:
		spawn_x = player.global_position.x - spawn_distance
	else:
		spawn_x = player.global_position.x + spawn_distance
	
	spawn_x = clamp(spawn_x, spawn_min_x, spawn_max_x)
	var spawn_y = player.global_position.y
	
	trash_instance.global_position = Vector2(spawn_x, spawn_y)
	trash_instance.set_collectable_trash(random_type, random_texture)
	
	get_parent().add_child(trash_instance)
	can_spawn = false
	
	print("LIXO SPAWNADO COM SUCESSO!")
	print("Tipo: ", random_type)
	print("Posicao X: ", spawn_x)
	print("Posicao Y: ", spawn_y)
	print("Lado: ", "ESQUERDA" if spawn_side == 0 else "DIREITA")
	print("Distancia do player: ", abs(spawn_x - player.global_position.x))

func _on_trash_collected():
	print("Player coletou o lixo")

func _on_trash_launched():
	print("Lixo foi lancado!")
	print("Liberando spawn...")
	can_spawn = true
	
	await get_tree().create_timer(0.5).timeout
	spawn_trash()
