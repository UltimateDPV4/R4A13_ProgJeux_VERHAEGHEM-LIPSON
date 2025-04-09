extends CanvasLayer

@export var image = load("res://Global/ImportImage/SpritePerso/Nextea PixelArt.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/Label.text = "00:00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var minutes := str(Global.timeScore / 60).pad_zeros(2)  # Calculer les minutes et s'assurer qu'il y a toujours deux chiffres
	var seconds := str(Global.timeScore % 60).pad_zeros(2)  # Calculer les secondes et s'assurer qu'il y a toujours deux chiffres
	$MarginContainer/Label.text = minutes + ":" + seconds
	$HBoxContainer2/numberCollectible.text = str(Global.collectible) + "/" + str(Global.maxCollectible)


func set_health(amount):
	# remove all children
	for child in $HBoxContainer.get_children():
		child.queue_free()
	# create new children amount is set by health
	for i in amount:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		$HBoxContainer.add_child(text_rect)
		text_rect.stretch_mode = TextureRect.STRETCH_SCALE
		text_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH


func set_collectible(amount, maxAmount):
	if (amount > maxAmount):
		amount = maxAmount
	$HBoxContainer2/numberCollectible.text = str(amount) + "/" + str(maxAmount)


func _on_timer_add_time_timeout() -> void:
	Global.timeScore += 1
