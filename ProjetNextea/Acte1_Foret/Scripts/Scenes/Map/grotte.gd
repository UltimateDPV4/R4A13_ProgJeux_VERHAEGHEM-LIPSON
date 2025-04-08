extends Node2D

@export var projectile_scene :PackedScene 
var flipDirectionProjectile := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.collectible = 0
	Global.maxCollectible = 2
	Global.maxAllCollectible += Global.maxCollectible
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!DialogManager.dialogActive):
		$Goulu.playIdleAnimation()


func _on_next_level_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		get_tree().change_scene_to_file("res://Acte1_Foret/Scenes/Tower.tscn")



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
