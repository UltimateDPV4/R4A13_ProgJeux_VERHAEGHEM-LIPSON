extends State

@export var attackDelay := 1.25  # Délai avant l'attaque

@onready var attackTimer := $TimerAttaqueMelee

func _ready():
	attackTimer.set_wait_time(attackDelay)
	attackTimer.set_one_shot(true)

func enter():
	print("Entering AttaqueMelee State")
	attackTimer.start()
	
func _on_timer_attaque_melee_timeout() -> void:
	# Logique pour effectuer l'attaque de mêlée
	print("Performing Melee Attack")
	
	# Appeler la fonction pour jouer l'animation et activer la collision
	get_tree().call_group('attaqueMelee', 'playAttackAnimation')
	get_tree().call_group('MalakarBoss', 'setAnimationBossFight', "attaque")
	get_parent().change_state("Idle")

func exit():
	print("Exiting AttaqueMelee State")
