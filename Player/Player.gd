extends CharacterBody2D

signal trash_collected
signal trash_launched

@onready var sfx_passos: AudioStreamPlayer = $sfx_passos

@export var speed = 900
@export var trash_scene: PackedScene
@export var collect_distance: float = 100.0

@onready var lixo_na_mao_sprite: Sprite2D = $LixoNaMaoSprite
@onready var ponto_de_lancamento: Marker2D = $PontoDeLancamento

var trash_textures = {
	"metal": preload("res://assets/metal_p.png"),
	"organico": preload("res://assets/organico_p.png"),
	"papel": preload("res://assets/papel_p.png"),
	"plastico": preload("res://assets/plastico_p.png"),
	"vidro": preload("res://assets/vidro_p.png")
}

var current_trash_type: String = ""
var current_trash_texture: Texture = null
var has_trash = false

const LIXO_MAO_SCALE = Vector2(0.25, 0.25)
const LIXO_MAO_POSITION = Vector2(0, -50)
const LIXO_ATIRADO_SCALE = Vector2(0.4, 0.4)

func _ready():
	print("")
	print("PLAYER INICIALIZADO")
	print("Posicao X: ", global_position.x)
	print("Posicao Y: ", global_position.y)
	print("Distancia de coleta: ", collect_distance)
	
	ponto_de_lancamento.position = Vector2(0, -50)
	lixo_na_mao_sprite.visible = false
	
	if not trash_scene:
		trash_scene = load("res://Trash/Trash.tscn")
		print("Trash scene carregada automaticamente")

func _physics_process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	velocity.x = direction * speed
	move_and_slide()
	
	# Lógica de som de passos
	if direction != 0:
		# Toca se não estiver tocando
		if not sfx_passos.is_playing():
			sfx_passos.play()
	else:
		# Para se estiver tocando e o jogador parou
		if sfx_passos.is_playing():
			sfx_passos.stop()
	
	position.x = clamp(position.x, 44, 789)
	
	if not has_trash:
		check_for_trash()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and has_trash:
		shoot()

func check_for_trash():
	var trash_group = get_tree().get_nodes_in_group("collectable_trash")
	
	if trash_group.size() > 0:
		print("")
		print("Checando ", trash_group.size(), " lixo(s) na cena...")
	
	for trash in trash_group:
		if trash and is_instance_valid(trash):
			var distance = global_position.distance_to(trash.global_position)
			
			if distance < collect_distance + 50:
				print("Distancia do lixo: ", distance, " (limite: ", collect_distance, ")")
			
			if distance < collect_distance:
				collect_trash(trash)
				break

func collect_trash(trash):
	if trash.is_collectable:
		print("")
		print("COLETANDO LIXO!")
		
		current_trash_type = trash.trash_type
		current_trash_texture = trash_textures[current_trash_type]
		
		lixo_na_mao_sprite.texture = current_trash_texture
		lixo_na_mao_sprite.visible = true
		lixo_na_mao_sprite.scale = LIXO_MAO_SCALE
		lixo_na_mao_sprite.position = LIXO_MAO_POSITION
		lixo_na_mao_sprite.z_index = 10
		
		has_trash = true
		trash.queue_free()
		
		trash_collected.emit()
		
		print("Tipo coletado: ", current_trash_type)
		print("Pressione ESPACO para lancar!")

func shoot():
	if not trash_scene or not has_trash:
		return
	
	print("")
	print("LANCANDO LIXO!")
	print("Tipo sendo lancado: ", current_trash_type)
	
	var trash_instance = trash_scene.instantiate()
	trash_instance.global_position = ponto_de_lancamento.global_position
	trash_instance.set_trash_properties(current_trash_type, current_trash_texture, LIXO_ATIRADO_SCALE)
	
	get_parent().add_child(trash_instance)
	
	lixo_na_mao_sprite.texture = null
	lixo_na_mao_sprite.visible = false
	has_trash = false
	
	trash_launched.emit()
	
	print("Lixo lancado com sucesso!")

func prepare_next_trash():
	pass
