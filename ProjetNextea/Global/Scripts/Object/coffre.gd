extends InteractionObject

@export var flipCoffre := false
var alreadyInteracted := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$coffreSprite.flip_h = flipCoffre
	add_to_group("canInteractive")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func startInteraction() -> void:
	if !alreadyInteracted:
		$coffreSprite.play("coffreOuverture")
		print("Open Coffre")
		alreadyInteracted = true
		Global.collectible += 1
		get_tree().call_group('UI', 'set_collectible', Global.collectible, Global.maxCollectible)
