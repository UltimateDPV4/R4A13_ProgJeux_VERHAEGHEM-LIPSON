extends CanvasLayer

@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.playerDeath = true

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("jump")):
		get_tree().change_scene_to_file(Global.sceneToRespawn)
