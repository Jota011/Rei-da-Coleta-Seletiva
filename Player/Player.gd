# Player.gd
extends CharacterBody2D

# --- Variáveis Exportadas (Ajustáveis no Inspetor) ---
@export var speed = 900
@export var trash_scene: PackedScene


# --- Referências de Nós Filhos ---
# Garante que temos uma referência ao sprite que mostra o lixo "em espera".
@onready var lixo_na_mao_sprite: Sprite2D = $LixoNaMaoSprite
# Garante que temos uma referência ao ponto exato de onde o lixo será lançado.
@onready var ponto_de_lancamento: Marker2D = $PontoDeLancamento


# --- Lógica do Jogo ---
# Dicionário que armazena os tipos de lixo e suas respectivas imagens.
var trash_types = {
	"metal": preload("res://Trash/metal.png"),
	"organico": preload("res://Trash/organico.png"),
	"papel": preload("res://Trash/papel.png"),
	"plastico": preload("res://Trash/plastico.png"),
	"vidro": preload("res://Trash/vidro.png")
}
# Uma lista com as chaves do dicionário para facilitar o sorteio.
var trash_keys = trash_types.keys()

# Variáveis para guardar o estado do lixo que está "na mão".
var current_trash_type: String
var current_trash_texture: Texture
var can_shoot = false # Controla se o jogador pode atirar


# Função chamada uma vez quando o nó entra na cena.
func _ready():
	# Prepara o primeiro lixo assim que o jogo começa.
	prepare_next_trash()


# Função chamada a cada frame de física. Ideal para movimento e física.
func _physics_process(delta):
	# 1. Pega o input das setas Esquerda (-1) e Direita (1).
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	# 2. Move o personagem.
	move_and_slide()

	# 3. Limita a posição do jogador às bordas da tela.
	#    Usa os limites exatos que você definiu: 44 e 789.
	position.x = clamp(position.x, 44, 789)


# Função chamada sempre que há um input (tecla, mouse, etc.).
func _unhandled_input(event):
	# Verifica se a tecla pressionada foi a de "aceitar" (Espaço, por padrão).
	if event.is_action_pressed("ui_accept"):
		# Só permite o tiro se a variável can_shoot for verdadeira.
		if can_shoot:
			shoot()


# Esta função é chamada pela cena 'Main' para preparar o próximo lixo.
func prepare_next_trash():
	# Sorteia um novo tipo de lixo aleatoriamente.
	current_trash_type = trash_keys[randi() % trash_keys.size()]
	current_trash_texture = trash_types[current_trash_type]
	
	# Atualiza a textura do sprite para mostrar qual lixo será o próximo.
	lixo_na_mao_sprite.texture = current_trash_texture
	can_shoot = true # Libera o próximo tiro!
	print("Novo lixo preparado: ", current_trash_type)


# Esta função lança o lixo que JÁ ESTAVA visível.
func shoot():
	# Verificação de segurança.
	if not trash_scene:
		print("ERRO: A cena do lixo (Trash Scene) não foi definida no Inspetor do Player!")
		return

	# Cria uma nova instância da cena do lixo.
	var trash_instance = trash_scene.instantiate()
	
	# Define as propriedades do lixo que será lançado (tipo e textura).
	trash_instance.set_trash_properties(current_trash_type, current_trash_texture)

	# Posiciona o novo lixo exatamente na posição do nosso Marker2D.
	trash_instance.global_position = ponto_de_lancamento.global_position

	# Adiciona o lixo à cena principal para que ele exista no jogo.
	get_parent().add_child(trash_instance)
	
	# Após atirar, esvazia a mão e impede novos tiros até o sinal de colisão.
	lixo_na_mao_sprite.texture = null
	can_shoot = false
