extends Node2D

@export var projectile_scene :PackedScene 
var flipDirectionProjectile := false
var talked := false
var showLetterF := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.collectible = 0
	Global.maxCollectible = 2
	Global.maxAllCollectible += Global.maxCollectible
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!DialogManager.dialogActive):
		if talked:
			if showLetterF:
				$"Tuto/Area2DTirer/Lettre-f".show()
				$"Tuto/Area2DInteragir3/Lettre-e".hide()
				if Input.is_action_just_pressed("attaque"):
					showLetterF = false
			else:
				$"Tuto/Area2DTirer/Lettre-f".hide()
			talked = false
		$Goulu.playIdleAnimation()
	else:
		talked = true


func _on_next_level_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		get_tree().change_scene_to_file("res://Acte1_Foret/Scenes/Map/Tower.tscn")



func _on_player_projectile(pos: Variant) -> void:
	var projectile = projectile_scene.instantiate()
	if projectile != null: # Vérication pour éviter les erreurs si le noeud parent n'existe pas
		projectile.scale = Vector2(0.2, 0.2)
		projectile.speed = 200
		$Projectiles.add_child(projectile)
		projectile.flipSprite(flipDirectionProjectile)
		projectile.position = pos


func _on_player_projectile_flip_direction(flip: Variant) -> void:
	flipDirectionProjectile = flip



func _on_area_2d_deplacer_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$Tuto/Area2DDeplacer/Boutons.show()

func _on_area_2d_deplacer_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$Tuto/Area2DDeplacer/Boutons.hide()


func _on_area_2d_sauter_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$Tuto/Area2DSauter/Espace.show()

func _on_area_2d_sauter_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$Tuto/Area2DSauter/Espace.hide()


func _on_area_2d_interagir_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$"Tuto/Area2DInteragir/Lettre-e".show()

func _on_area_2d_interagir_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$"Tuto/Area2DInteragir/Lettre-e".hide()


func _on_area_2d_interagir_2_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$"Tuto/Area2DInteragir2/Lettre-e".show()

func _on_area_2d_interagir_2_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$"Tuto/Area2DInteragir2/Lettre-e".hide()


func _on_area_2d_interagir_3_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player") and !talked):
		$"Tuto/Area2DInteragir3/Lettre-e".show()
	
func _on_area_2d_interagir_3_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$"Tuto/Area2DInteragir3/Lettre-e".hide()


func _on_area_2d_tirer_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		showLetterF = true

func _on_area_2d_tirer_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		showLetterF = false
