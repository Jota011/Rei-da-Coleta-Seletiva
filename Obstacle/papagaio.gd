# papagaio.gd
extends CharacterBody2D

@export var speed: float = 250
@export var direction: int = 1
@export var collision_radius: float = 50.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

func _ready():
	if randi() % 2 == 0:
		direction = 1
	else:
		direction = -1
	
	update_sprite_direction()
	anim.play("fly")
	
	set_collision_layer_value(4, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)

func _physics_process(delta):
	global_position.x += direction * speed * delta
	
	check_collisions()
	
	if global_position.x < -200:
		global_position.x = 1200
		direction = 1
		update_sprite_direction()
	elif global_position.x > 1200:
		global_position.x = -200
		direction = -1
		update_sprite_direction()

func check_collisions():
	# 1. Verifica colisão com LIXO LANÇADO
	var trash_nodes = get_tree().get_nodes_in_group("launched_trash")
	for trash in trash_nodes:
		if is_instance_valid(trash):
			var distance = global_position.distance_to(trash.global_position)
			if distance < collision_radius:
				print("🦜 Papagaio atingido pelo lixo! Desperdiçou o lixo - Perde vida.")
				
				# PERDE VIDA e TOCA SOM
				var main_node = get_tree().get_first_node_in_group("main_game_manager")
				if main_node:
					# Toca o som de miss/perda
					if main_node.has_node("sfx_miss"):
						main_node.get_node("sfx_miss").play()
					
					# Perde apenas vida, sem mexer no score
					main_node.lives -= 1
					main_node.update_lives_display()
					
					if main_node.lives <= 0:
						main_node.game_over()
				
				# Destrói o LIXO e o PAPAGAIO
				trash.queue_free()
				queue_free()
				return
	
	# 2. Verifica colisão com PLAYER
	var player = get_tree().get_first_node_in_group("player")
	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		if distance < collision_radius:
			print("💥 Papagaio atingiu o Player! Aplicando dano.")
			
			var main_node = get_tree().get_first_node_in_group("main_game_manager")
			if main_node and main_node.has_method("on_player_hit"):
				main_node.on_player_hit()
			
			queue_free()

func update_sprite_direction():
	anim.flip_h = (direction == 1)
