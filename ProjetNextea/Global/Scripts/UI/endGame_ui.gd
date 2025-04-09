extends CanvasLayer

@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var minutes := str(Global.timeScore / 60).pad_zeros(2)  # Calculer les minutes et s'assurer qu'il y a toujours deux chiffres
	var seconds := str(Global.timeScore % 60).pad_zeros(2)  # Calculer les secondes et s'assurer qu'il y a toujours deux chiffres
	$CenterContainer/VBoxContainer/Score.text = "Nombre Coffres trouves : " + str(Global.numberCollectedCollectible) + "/" + str(Global.maxAllCollectible)
	$CenterContainer/VBoxContainer/Score2.text =  "Temps passe : " + str(minutes) + ":" + str(seconds)

func _process(delta: float) -> void:
	pass
