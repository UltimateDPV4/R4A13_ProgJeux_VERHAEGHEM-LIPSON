extends InteractionObject

signal startDialog

func _ready() -> void:
	add_to_group("canInteractive")


func _process(delta: float) -> void:
	pass


func startInteraction():
	startDialog.emit()
