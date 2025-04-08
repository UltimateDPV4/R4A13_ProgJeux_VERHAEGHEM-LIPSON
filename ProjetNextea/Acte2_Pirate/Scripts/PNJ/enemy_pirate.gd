extends CharacterBody2D

@export var speedToJumpIntoScene := 100
@export var speed := 75  # Vitesse de déplacement de l'ennemi
@export var attackRange := 200  # Portée d'attaque
@onready var sprite := $Enemy

var playerPosition := Vector2.ZERO
var direction := Vector2.ZERO
var spawnToScene := true
var jumpToScene := false

signal collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var random_x = rng.randi_range(-150, 150)
	
	# Le pirate va spawn n'importe où tout du long du plancher du bateau (random_x) et derrière le plancher pour ne pas être visible (50)
	position = Vector2(random_x, 50)
	
	# Modifie le Ordering z_index pour que le pirate soit derrière le bateau
	set_z_index(0)
	
	# Désactive la collision pour éviter les dégâts pendant le spawn
	$CollisionShape2D.disabled = true
	add_to_group("enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if spawnToScene:
		spawnEnemyPirate(delta)
	else:
		# Active la collision une fois le spawn terminé
		$CollisionShape2D.disabled = false
		moveTowardsPlayer(delta)

func _physics_process(delta: float) -> void:
	print("Enemy :" + str(direction.length()))
	# Vérifiez si le joueur est à portée pour attaquer
	if direction.length() <= attackRange and !spawnToScene:
		attackPlayer()
	else: 
		velocity = direction.normalized() * speed
		move_and_slide()

# Fonction utilisée pour faire l'effet de l'apparition de l'enemy qui monte sur le bateau
func spawnEnemyPirate(delta: float) -> void:
	# Déplacer le pirate vers le haut jusqu'à ce qu'il atteigne y = 0 (être légèrement au dessus du plancher)
	if position.y > 0 and !jumpToScene:
		position.y -= speedToJumpIntoScene * delta
		if position.y <= 0:
			position.y = 0
			set_z_index(2)
			jumpToScene = true
			#print("JumpToScene")
				
	# Déplacer le pirate vers le bas jusqu'à ce qu'il atteigne y = 37 (être sur le plancher du bateau)
	elif position.y < 37 and jumpToScene:
		position.y += speedToJumpIntoScene * delta
		if position.y >= 37:
			position.y = 37
			#print("EndToJumpToScene")
			spawnToScene = false


func moveTowardsPlayer(delta: float) -> void:
	# Obtenez la position du joueur
	var player = get_tree().get_first_node_in_group("player")
	if player:
		if (player.global_position.x <= global_position.x):
			flipSprite(true)
			$Enemy/AttaqueMelee.position.x = -215
			$Enemy/AttaqueMelee/AttaqueMelee.flip_h = true
			direction.x = player.global_position.x - global_position.x
		else:
			flipSprite(false)
			$Enemy/AttaqueMelee.position.x = 215
			$Enemy/AttaqueMelee/AttaqueMelee.flip_h = false
			direction.x = player.global_position.x + global_position.x


func attackPlayer() -> void:
	$TimerAttaque.start()
	set_physics_process(false)


func flipSprite(flip: bool) -> void:
	sprite.flip_h = flip


func _on_timer_attaque_timeout() -> void:
	$Enemy/AttaqueMelee.playAttackAnimation()
	set_physics_process(true)
