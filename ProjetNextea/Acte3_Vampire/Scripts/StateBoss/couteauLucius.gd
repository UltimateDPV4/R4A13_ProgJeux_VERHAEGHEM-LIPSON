extends State

@export var knifeScene: PackedScene  # Scène du couteau
@export var aimDuration := 1.25  # Durée de visée
@export var waitDuration := 1  # Durée de visée

var isAiming := false
var knives := []
@onready var aimTimer := $TimerLancerCouteau
@onready var waitBeforeSpawnTimer := $TimerWaitBeforeSpawn
@onready var waitAfterSpawnTimer := $TimerWaitAfterSpawn
@onready var waitChangeStateTimer := $TimerWaitChangeState

func _ready():
	aimTimer.set_wait_time(aimDuration)
	aimTimer.set_one_shot(true)
	waitBeforeSpawnTimer.set_wait_time(waitDuration)
	waitBeforeSpawnTimer.set_one_shot(true)
	waitAfterSpawnTimer.set_wait_time(waitDuration)
	waitAfterSpawnTimer.set_one_shot(true)
	waitChangeStateTimer.set_wait_time(waitDuration)
	waitChangeStateTimer.set_one_shot(true)

func enter():
	print("Entering Couteau State")
	isAiming = true
	for i in range(3):
		var knife = knifeScene.instantiate()
		owner.get_parent().add_child(knife)
		knife.position = owner.global_position + Vector2(-150 + i * 150, -50)  # Position à côté de Lucius avec un léger décalage
		knives.append(knife)
	get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "teleportInverse")
	
	waitAfterSpawnTimer.start()


func _on_timer_wait_after_spawn_timeout() -> void:
	for i in range(3):
		var knife = knifeScene.instantiate()
		owner.get_parent().add_child(knife)
		knife.position = owner.global_position + Vector2(-150 + i * 150, -50)  # Position à côté de Lucius avec un léger décalage
		knives.append(knife)
	get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "invocationCouteau")
	# Démarrer le timer de visée
	aimTimer.start()

func _on_timer_lancer_couteau_timeout() -> void:
	# Lancer le couteau vers le joueur
	if player:
		for knife in knives:
			if knife:
				var direction = (player.global_position - knife.global_position).normalized()
				# Calculer l'angle de rotation en radians
				var angle = atan2(direction.y, direction.x)
				knife.setRotation(angle)
	isAiming = false
	
	get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "teleport")
	waitBeforeSpawnTimer.start()


func _on_timer_wait_before_spawn_timeout() -> void:
	get_tree().call_group('LuciusBoss', 'setAnimationBossFight', "teleportInverse")
	var rng = RandomNumberGenerator.new()
	var random_x = rng.randi_range(150, 1145)
	owner.global_position = Vector2(random_x, 615)	
	
	waitChangeStateTimer.start()

func _on_timer_wait_change_state_timeout() -> void:
	get_parent().change_state("Idle")

func exit():
	print("Exiting Couteau State")
	isAiming = false
