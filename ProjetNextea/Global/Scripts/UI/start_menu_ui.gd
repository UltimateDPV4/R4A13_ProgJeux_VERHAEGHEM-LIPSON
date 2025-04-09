extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		get_tree().change_scene_to_file("res://Acte1_Foret/Scenes/Map/Grotte.tscn")
