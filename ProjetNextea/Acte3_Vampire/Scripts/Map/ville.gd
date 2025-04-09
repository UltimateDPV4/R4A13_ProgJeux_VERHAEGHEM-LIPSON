extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.numberCollectedCollectible += Global.collectible
	Global.collectible = 0
	Global.maxCollectible = 4
	Global.maxAllCollectible += Global.maxCollectible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_level_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		get_tree().change_scene_to_file("res://Acte3_Vampire/Scenes/Map/cathedrale_boss.tscn")
