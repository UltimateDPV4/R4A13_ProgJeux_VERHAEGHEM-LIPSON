extends State

@export var idleDuration := 0.9  # Durée d'attente en secondes

@onready var idleTimer := $TimerIdle

func _ready():
	idleTimer.set_wait_time(idleDuration)
	idleTimer.set_one_shot(true)

func enter():
	print("Entering Idle State")
	get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "idle")
	idleTimer.start()

func _on_timer_idle_timeout() -> void:
	# Passer à l'état Teleport après le délai
	get_parent().change_state("Teleport")

func exit():
	print("Exiting Idle State")
	idleTimer.stop()
