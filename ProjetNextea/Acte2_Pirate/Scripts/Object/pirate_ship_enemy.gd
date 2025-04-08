extends Node2D

@export var speedToNavigate := 10

var introBoss := true
var startApparition := false
var startBecauseMusic := false
var startAnimationCharge := false
var startPlacementToCharge := false
var charged := false
var change_random_x := false

var rng = RandomNumberGenerator.new()
var randomX
var oldRandomX

signal chargedShipEnemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomX = rng.randi_range(-125, 75)
	position = Vector2(250, -20)
	scale = Vector2(0.2, 0.2)
	set_z_index(-2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationPlayer.play("Navigation")
	
	if introBoss:
		if startApparition:
			if (position.x > 125):
				position.x -= 10 * delta
			else:
				position.x  = 125
		if !DialogManager.dialogActive and position.x == 125:
			introBoss = false
	else:	
		if Input.is_action_just_pressed("debugMiseEnScene") or startBecauseMusic:
			startAnimationCharge = true
			startBecauseMusic = false	
	
		if !startAnimationCharge and !charged and !startBecauseMusic:
			if position.x < randomX:
				position.x += speedToNavigate * delta
				if position.x >= randomX:
					change_random_x = true
			else :
				position.x -= speedToNavigate * delta
				if position.x <= randomX:
					change_random_x = true	
	
		if startAnimationCharge and !charged:
			startCharge(delta)


func startCharge(delta: float) -> void:
	# Déplacer le bateau vers la position finale (0, -80) et ajuster sa taille
	if position.x != 0 or position.y > -80 or scale.x < 0.8 or scale.y < 0.8:
		# Déplacer le bateau vers la gauche
		if position.x > 0:
			position.x -= (speedToNavigate + 40) * delta
			set_z_index(0)
			if position.x < 0:
				position.x = 0
		elif position.x < 0:
			position.x += (speedToNavigate + 40) * delta
			set_z_index(0)
			if position.x > 0:
				position.x = 0

		# Déplacer le bateau vers le bas
		if position.y > -80:
			position.y -= (speedToNavigate + 15) * delta
			if position.y < -80:
				position.y = -80

		# Augmenter la taille du bateau
		if scale.x < 0.8:
			scale.x += 0.25 * delta
			if scale.x > 0.8:
				scale.x = 0.8

		if scale.y < 0.8:
			scale.y += 0.25 * delta
			if scale.y > 0.8:
				scale.y = 0.8
	else:
		print("EndToCharge")
		startAnimationCharge = false
		charged = true
		chargedShipEnemy.emit()


func changeRandomX():
	if change_random_x:
		oldRandomX = randomX
		randomX = rng.randi_range(-125,125)
		
		while abs(randomX - oldRandomX) < 50:
			randomX = rng.randi_range(-125,125)
		
		print("Old : ", oldRandomX, " / New : ", randomX)
		change_random_x = false


func startChargeByMusic():
	startBecauseMusic = true


func _on_ship_boss_start_apparition_ship_boss() -> void:
	startApparition = true
