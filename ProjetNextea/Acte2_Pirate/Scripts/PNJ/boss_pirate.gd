extends CharacterBody2D

@onready var sprite := $"Malakar Voidwalker"
@onready var player = get_tree().root.get_node("ShipBoss/Player")
@export var moveSpeed := 75  # Vitesse de déplacement
@export var attackRange := 175.0  # Distance d'attaque sur l'axe x

var flipping := false
var canMove := false
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionPolygon2D.disabled = true
	set_physics_process(false)
	add_to_group("boss")


func _physics_process(delta: float) -> void:
	if canMove:
		if (player.global_position.x <= global_position.x):
			flipSprite(false)
			$"Malakar Voidwalker/AttaqueMelee".position.x = -125
			$"Malakar Voidwalker/AttaqueMelee/AttaqueMelee".flip_h = true
			direction.x = player.global_position.x - global_position.x
		else:
			flipSprite(true)
			$"Malakar Voidwalker/AttaqueMelee".position.x = 125
			$"Malakar Voidwalker/AttaqueMelee/AttaqueMelee".flip_h = false
			direction.x = player.global_position.x - global_position.x
			
		velocity = direction.normalized() * moveSpeed
		move_and_slide()
		
		print("Boss :" + str(direction.length()))
		# Vérifiez si le joueur est à portée pour attaquer
		if direction.length() <= attackRange and direction.length() != 0:
			attackPlayer()


func attackPlayer() -> void:
	$Timer.start()
	canMove = false


func flipSprite(flip: bool) -> void:
	sprite.flip_h = flip


func setAnimationBossFight(nameSprite) -> void:
	sprite.play(nameSprite)

		
func _on_ship_boss_start_boss_fight() -> void:
	$CollisionPolygon2D.disabled = false
	set_physics_process(true)
	canMove = true

func _on_timer_timeout() -> void:
	$"Malakar Voidwalker".play("attaque")
	$"Malakar Voidwalker"/AttaqueMelee.playAttackAnimation()
	$TimerBeforeMoveAgain.start()


func _on_timer_before_move_again_timeout() -> void:
	canMove = true


func _on_health_boss_death_boss() -> void:
	canMove = false
	$CollisionPolygon2D.disabled = true
	set_physics_process(false)
	remove_from_group("boss")
	hide()
