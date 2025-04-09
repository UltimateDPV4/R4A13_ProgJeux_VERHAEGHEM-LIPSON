extends CanvasLayer

signal deathBoss

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProgressBar/Label.text = "No Name Selected"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.value = Global.healthBoss
	
	if $ProgressBar.value <= 0.0:
		deathBoss.emit()
		Global.healthBoss = 100


func setNameBoss(name: String) -> void:
	$ProgressBar/Label.text = name

func setMaxHelthBoss(value: float)-> void:
	$ProgressBar.max_value = value
