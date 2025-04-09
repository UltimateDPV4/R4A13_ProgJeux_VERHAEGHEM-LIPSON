extends Area2D

@onready var sprite := $AttaqueMelee

var flipping := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("melee")
	$CollisionPolygon2D.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") && $CollisionPolygon2D.disabled == false:
		print("Collision AttaqueMelee Nextea")
		Global.health -= 1
		get_tree().call_group('UI', 'set_health', Global.health)
		if Global.health <= 0:
			get_tree().change_scene_to_file("res://Global/Scenes/UI/game_over_ui.tscn")

func flipSprite(flip) -> void:
	flipping = flip
	sprite.flip_h = flip

func playAttackAnimation() -> void:
	# Jouer l'animation d'attaque
	$AttaqueMelee.play("Attaque")
	# Activer la collision
	$CollisionPolygon2D.disabled = false

func _on_attaque_melee_animation_finished() -> void:
	$CollisionPolygon2D.disabled = true
	$AttaqueMelee.stop()
	$AttaqueMelee.frame = 0
	
