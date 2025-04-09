extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for Goulu in $Node2D.get_children():
		Goulu.play("idle")
		Goulu.add_to_group("enemy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") && $CollisionPolygon2D.disabled == false:
		print("Collision Nextea")
		Global.health -= 1
		get_tree().call_group('UI', 'set_health', Global.health)
		if Global.health <= 0:
			get_tree().change_scene_to_file("res://Global/Scenes/UI/game_over_ui.tscn")
		$CollisionPolygon2D.disabled = true
