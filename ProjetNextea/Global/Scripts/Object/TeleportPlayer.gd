extends InteractionObject

signal teleportPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("canInteractive")
	add_to_group("alwaysInteractive")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func startInteraction() -> void:
	print("StartInteractionTeleportPlayer")
	teleportPlayer.emit()
