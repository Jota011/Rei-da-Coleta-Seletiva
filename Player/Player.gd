# Player.gd
extends CharacterBody2D

# --- Variáveis Exportadas ---
@export var speed = 900
@export var trash_projectile_scene: PackedScene  # Cena do projetil (Trash.tscn)

# --- Referências de Nós ---
@onready var lixo_na_mao_sprite: Sprite2D = $LixoNaMaoSprite
@onready var ponto_de_lancamento: Marker2D = $PontoDeLancamento

# --- Dados ---
var trash_types = {
	"metal": preload("res://Trash/metal.png"),
	"organico": preload("res://Trash/organico.png"),
	"papel": preload("res://Trash/papel.png"),
	"plastico": preload("res://Trash/plastico.png"),
	"vidro": preload("res://Trash/vidro.png")
}

var has_trash = false
var current_trash_type: String
var current_trash_texture: Texture

# --- Ready ---
func _ready():
	lixo_na_mao_sprite.texture = null

# --- Movimento ---
func _physics_process(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	move_and_slide()

	position.x = clamp(position.x, 44, 789)

# --- Input ---
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if has_trash:
			shoot()

# --- Coleta ---
func collect_trash(type: String, texture: Texture):
	if has_trash:
		return  # Já tem lixo na mão
	has_trash = true
	current_trash_type = type
	current_trash_texture = texture
	lixo_na_mao_sprite.texture = texture
	print("♻️ Lixo coletado:", type)

# --- Arremesso ---
func shoot():
	if not trash_projectile_scene:
		push_error("❌ Cena do lixo projetil não atribuída!")
		return

	var projectile = trash_projectile_scene.instantiate()
	projectile.set_trash_properties(current_trash_type, current_trash_texture)
	projectile.global_position = ponto_de_lancamento.global_position
	get_parent().add_child(projectile)

	print("🚀 Arremessou:", current_trash_type)

	lixo_na_mao_sprite.texture = null
	has_trash = false
