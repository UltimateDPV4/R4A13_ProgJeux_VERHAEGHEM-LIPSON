extends CharacterBody2D

@export var maxHealth := 3
@export var dash_distance := 75
@export var speed := 150
@export var jump := -300
@onready var sprite := $SpriteNextea

var talking := false
var shooting := false
var apply_gravity := true

signal projectile(pos)
signal projectileFlipDirection(flip)
signal interacted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	$Interaction.hide()
	Global.maxHealth = maxHealth

func _on_projectile_timer_timeout() -> void:
	shooting = false

# Cette fonction gère la physique du player
func _physics_process(delta: float) -> void:	
	# gère la gravité
	if apply_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta
	
		# is_on_floor vérifie si en cas le personnage touche le sol
		if Input.is_action_just_pressed("jump") && is_on_floor():
			# effectue le saut
			sprite.play("Jumping")
			velocity.y = jump
	
		var direction = Input.get_axis("ui_left", "ui_right")
		if Input.is_action_pressed("ui_left"):
			sprite.flip_h = false
			projectileFlipDirection.emit(false)
			$ProjectilePoint.position.x = -200
		
		if Input.is_action_pressed("ui_right"):
			sprite.flip_h = true
			projectileFlipDirection.emit(true)
			$ProjectilePoint.position.x = 200
		
		if Global.canInteract: 
			$Interaction.show()
			if Input.is_action_just_pressed("interaction"):
				print("Press Interaction")
				get_tree().call_group('InteractionObject', '_on_interaction_button_pressed')
		else:
			$Interaction.hide()
		
		if !talking and apply_gravity:
			velocity.x = direction * speed
	
			if velocity == Vector2(0,0):
				sprite.play("Idle")
			else:
				# is_on_floor vérifie si en cas le personnage touche le sol
				if is_on_floor():
					sprite.play("Walking")
		
			move_and_slide()
		
		if Input.is_action_just_pressed("attaque") and !shooting and apply_gravity:
			projectile.emit($ProjectilePoint.global_position)
			shooting = true
			$ProjectileTimer.start()


func _on_ship_boss_position_player(newPosition: Vector2) -> void:
	position = newPosition 


func _on_ship_boss_use_gravity(useGravity: bool) -> void:
	if useGravity:
		set_collision_layer_value(1, true)
		apply_gravity = true
	else:
		set_collision_layer_value(1, false)
		apply_gravity = false


func _on_timer_if_damage_timeout() -> void:
	Global.takeDamage = false
