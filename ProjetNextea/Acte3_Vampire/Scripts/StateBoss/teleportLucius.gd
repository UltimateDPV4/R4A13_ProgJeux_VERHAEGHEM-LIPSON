extends State

@export var teleportDelay := 1.25  # Délai avant la téléportation

@onready var teleportTimer := $TimerTeleport

func _ready():
	teleportTimer.set_wait_time(teleportDelay)
	teleportTimer.set_one_shot(true)

func enter():
	print("Entering Teleport State")
	get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "teleport")
	teleportTimer.start()

func _on_timer_teleport_timeout() -> void:
	print("EndTimer")
	if player:
		print("DetectPlayer")
		var random = randi() % 2
		if random == 0:
			print("Teleport Hauteur")
			# Téléporter en hauteur
			owner.global_position = Vector2(640, 200)
			get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "teleportInverse")
			get_parent().change_state("Couteau")
		else:
			print("Teleport Derriere")
			# Téléporter derrière le joueur
			owner.global_position = player.global_position + Vector2(-100, 0)
			if owner.global_position.y != 615:
				owner.global_position.y = 615
			get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "teleportInverseAttaqueMelee")
			get_parent().change_state("AttaqueMelee")
			
func exit():
	print("Exiting Teleport State")
