extends State

@onready var playerInScene = get_tree().root.get_node("ShipBoss/Player")
@onready var boss = get_tree().root.get_node("ShipBoss/Scene/PirateShipFloor/ShipFloorEnemy/bossPirate")

@export var idleDuration := 0.9  # Durée d'attente en secondes
@export var attackRange := 100.0  # Distance d'attaque sur l'axe x

@onready var idleTimer := $TimerIdle

func _ready():
	idleTimer.set_wait_time(idleDuration)
	idleTimer.set_one_shot(true)

func enter():
	print("Entering Idle State")
	get_tree().call_group('MalakarBoss', 'setAnimationBossFight', "idle")
	idleTimer.start()

func _on_timer_idle_timeout() -> void:
	# Calculer la distance entre le boss et le joueur sur l'axe x
	var distance_to_player = abs(boss.global_position.x - playerInScene.global_position.x)

	print(distance_to_player)
	if distance_to_player <= attackRange:
		# Passer à l'état Attaque si le joueur est à portée
		get_parent().change_state("AttaqueMelee")
	else:
		# Passer à l'état Deplacement si le joueur est hors de portée
		get_parent().change_state("Deplacement")

func exit():
	print("Exiting Idle State")
	idleTimer.stop()
