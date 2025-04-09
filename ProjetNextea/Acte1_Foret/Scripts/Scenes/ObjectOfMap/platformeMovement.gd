extends CharacterBody2D

@export var speed := 75.0
var target_position
var pointA 
var pointB
var canMove := false

func _ready() -> void:
	pointA = $initialPosition.global_position
	pointB = $finalPosition.global_position

func _process(delta: float) -> void:
	if (canMove):
		print("MovePlateforme")
		# Calculer la direction vers la position cible
		var direction = (target_position - global_position).normalized()

		# Déplacer la plateforme dans cette direction
		global_position += direction * speed * delta

		# Vérifier si la plateforme a atteint la position cible
		if global_position.distance_to(target_position) < speed * delta:
			global_position = target_position
			canMove = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player") and !canMove):
		print("PlayerDetectedPlateforme")
		if (target_position == pointA):
			target_position = pointB
		elif (target_position == pointB):
			target_position = pointA
		else:
			target_position = pointB
		canMove = true
