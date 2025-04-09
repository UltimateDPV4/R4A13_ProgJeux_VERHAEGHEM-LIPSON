extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShipFloorEnemy.hide()

	$ShipFloorEnemy/Caisse/StaticBody2D/CollisionShape2D.disabled = true
	$ShipFloorEnemy/Caisse2/StaticBody2D/CollisionShape2D.disabled = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationPlayer.play("Navigation")
	


func _on_ship_boss_change_sprite_floor_ally(changedFloorAlly: bool) -> void:
	if changedFloorAlly:
		$ShipFloorAlly.hide()
		$ShipFloorEnemy.show()
	else:
		$ShipFloorAlly.show()
		$ShipFloorEnemy.hide()



func _on_ship_boss_start_boss_fight() -> void:
	$ShipFloorEnemy/Caisse/StaticBody2D/CollisionShape2D.disabled = false
	$ShipFloorEnemy/Caisse2/StaticBody2D/CollisionShape2D.disabled = false
