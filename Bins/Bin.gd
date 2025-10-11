# Bin.gd
extends Area2D

@export var accepts_type: String

# --- MODIFICADO: O sinal agora envia um valor booleano (verdadeiro/falso) ---
signal trash_collided(was_correct: bool)

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.has_method("set_trash_properties"):
		return

	if body.trash_type == accepts_type:
		print("ACERTOU!")
		# Emite o sinal dizendo que o acerto foi CORRETO (true)
		emit_signal("trash_collided", true)
	else:
		print("ERROU na lixeira!")
		# Emite o sinal dizendo que o acerto foi INCORRETO (false)
		emit_signal("trash_collided", false)
		
	body.queue_free()
