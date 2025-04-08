extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.numberCollectedCollectible += Global.collectible
	Global.collectible = 0
	Global.maxCollectible = 4
	Global.maxAllCollectible += Global.maxCollectible
	$NextLevel/CollisionShape2D.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!DialogManager.dialogActive):
		$Player.jump = -350
		$Player.speed = 150
	else:
		$Player.jump = 0
		$Player.speed = 0

func _on_oliver_blackwood_start_talking() -> void:
	$NextLevel/CollisionShape2D.set_deferred("disabled", false)


func _on_next_level_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		get_tree().change_scene_to_file("res://Acte2_Pirate/Scenes/ShipBoss.tscn")
