extends Node2D

@export var enemy_pirate_scene :PackedScene 
@export var projectile_scene :PackedScene 
@export var musicShipBoss :AudioStreamMP3
@export var targetPositionMusicPlayback := 85.0
@export var nameBoss := "Malakar Voidwalker, L'Écorcheur des Profondeurs"
@export var targetHealthToSecondPhaseForBoss := 50.0

var numeroLineBoxDialog := 1

var flipDirectionProjectile := false
var changeScene := false
var pirateBossDeath := false
var introBattleBoss := true
var introBattleBoss2 := false
var beginAutoDialog := false
var deathFirstBoss := false

signal startApparitionShipBoss
signal startApparitionLeviathanBoss
signal positionPlayer
signal useGravity
signal changeSpriteFloorAlly
signal startBossFight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.health = 3
	Global.numberEnemy = 0
	Global.healthBoss = 70.0

	get_tree().call_group('UI', 'set_health', Global.health)
	
	positionPlayer.emit(Vector2(675, 620))
	$HealthBoss.hide()
	$HealthBoss.setMaxHelthBoss(Global.healthBoss)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if introBattleBoss:
		$Player.jump = 0
		$Player.speed = 0
		
		if !beginAutoDialog:
			beginAutoDialog = true
			$PirateEnemyTimer.stop()
			$OliverBlackwood.startBossDialog()
		
		
		if DialogManager.currentLineIndex == 9:
			startApparitionShipBoss.emit()
		
		if !DialogManager.dialogActive:
			$MusicAudio.stream = musicShipBoss
			$MusicAudio.play()
			$PirateEnemyTimer.start()
			introBattleBoss = false
			beginAutoDialog = false
	elif introBattleBoss2:
		$Player.jump = 0
		$Player.speed = 0
		
		if !beginAutoDialog:
			beginAutoDialog = true
			$PirateEnemyTimer.stop()
			$OliverBlackwood.startBossDialog2()
		
	
		if DialogManager.currentLineIndex == 4:
			startApparitionLeviathanBoss.emit()
		
		if !DialogManager.dialogActive:
			$MusicAudio.stream = musicShipBoss
			$MusicAudio.play()
			get_tree().change_scene_to_file("res://Acte3_Vampire/Scenes/Ville.tscn")
	else:
		if !deathFirstBoss:
			firstPhaseBossBattle(delta)
		else:
			secondPhaseBossBattle(delta)


func firstPhaseBossBattle(delta: float):
	$MusicAudio.volume_db = 5
	$Player.jump = -700
	$Player.speed = 350
		
	# positionMusicPlayback va récupérer le temps écoulé de la lecture
	var positionMusicPlayback = $MusicAudio.get_playback_position()
	
	$OliverBlackwood/OliverBlackwoodSprite.flip_h = true
	$OliverBlackwood/OliverBlackwoodSprite.play("walking")
	$OliverBlackwood.global_position.x += 400 * delta
		
	if Global.numberEnemy < 2:
		$PirateEnemyTimer.wait_time = 1.5
	else:
		$PirateEnemyTimer.wait_time = 2
	
	if $MusicAudio.playing:	
		# Si on arrive à un moment précis de la musique alors on déclenche la cinématique
		if positionMusicPlayback >= targetPositionMusicPlayback:
			_start_declenche_charge_by_music()
	
	if changeScene:
		if $Scene.position.y < 1750:
			$Scene.position.y += 1000 * delta
			if $Scene.position.y >= 1750:
				$Scene.position.y = 1750
				changeSpriteFloorAlly.emit(true)
				$Scene/PirateShipEnemy.hide()
				changeScene = false
			$Player.rotation += 5 * delta
			
			# Vérifiez si EnemyPirateSpawn a des enfants
			if $EnemyPirateSpawn.get_child_count() > 0:
				# Obtenez la liste des enfants
				var children = $EnemyPirateSpawn.get_children()
				# Suppression de chaque pirate existant 
				for child in children:
					child.set_physics_process(false)
					child.rotation += 7.5 * delta
					child.position.y -= 10 * delta
					child.remove_from_group("enemy")
			
		if $Background.position.y < 20:
			$Background.position.y += 50 * delta
			if $Background.position.y >= 20:
				$Background.position.y = 20
	else:
		if $Scene.position.y > 382:
			$Scene.position.y -= 1000 * delta
			if $Scene.position.y <= 382:
				$Scene.position.y = 382
				useGravity.emit(true)
				_start_boss_fight()
				
				
			$Player.rotation += 5 * delta
			if $Player.position.x > 400:
				$Player.position.x -= 10 * delta
				if $Player.position.x < 400:
					$Player.position.x = 400
			if $Player.position.x < 400:
				$Player.position.x += 10 * delta
				if $Player.position.x > 400:
					$Player.position.x = 400
			
			# Vérifiez si EnemyPirateSpawn a des enfants
			if $EnemyPirateSpawn.get_child_count() > 0:
				# Obtenez la liste des enfants
				var children = $EnemyPirateSpawn.get_children()
				# Suppression de chaque pirate existant 
				for child in children:
					child.rotation += 7.5 * delta
					child.set_z_index(-1)
					child.position.y += 30 * delta
				
		else:
			$Player.rotation = 0
			
		if $Background.position.y > -98:
			$Background.position.y -= 50 * delta
			if $Background.position.y <= -98:
				$Background.position.y = -98


func secondPhaseBossBattle(delta: float):

	$OliverBlackwood/OliverBlackwoodSprite.flip_h = false
	$OliverBlackwood/OliverBlackwoodSprite.play("idle")
	$OliverBlackwood.hide()
	$OliverBlackwood.global_position = Vector2(900, 630)
	
	if changeScene:
		if $Scene.position.y < 1750:
			$Scene.position.y += 1000 * delta
		
		if $Scene.position.y >= 1750:
			$Scene.position.y = 1750
			changeSpriteFloorAlly.emit(false)
			changeScene = false
		
		$Player.rotation += 5 * delta
			
		if $Background.position.y < 20:
			$Background.position.y += 50 * delta
			if $Background.position.y >= 20:
				$Background.position.y = 20
	else:
		if $Scene.position.y > 382:
			$Scene.position.y -= 1000 * delta
			if $Scene.position.y <= 382:
				$Scene.position.y = 382
				useGravity.emit(true)
				$OliverBlackwood.show()
			$Player.rotation += 5 * delta
				
		else:
			$Player.rotation = 0
			
		if $Background.position.y > -98:
			$Background.position.y -= 50 * delta
			if $Background.position.y <= -98:
				$Background.position.y = -98
	
	if !changeScene and $Scene.position.y == 382:
		introBattleBoss2 = true
		$Player.rotation = 0




func _start_declenche_charge_by_music() -> void:
	$Scene/PirateShipEnemy.startChargeByMusic()

func _start_boss_fight() -> void:
	$HealthBoss.show()
	$HealthBoss.setNameBoss(nameBoss)
	
	startBossFight.emit()
	
	if Global.health < Global.maxHealth : 
		Global.health = Global.maxHealth
		get_tree().call_group('UI', 'set_health', Global.health)
	
	# Vérifiez si EnemyPirateSpawn a des enfants
	if $EnemyPirateSpawn.get_child_count() > 0:
		# Obtenez la liste des enfants
		var children = $EnemyPirateSpawn.get_children()
		# Suppression de chaque pirate existant 
		for child in children:
			child.queue_free()





func _on_pirate_enemy_timer_timeout() -> void:
	if Global.numberEnemy < 3:
		var enemy_pirate = enemy_pirate_scene.instantiate()

		if enemy_pirate != null: # Vérication pour éviter les erreurs si le noeud parent n'existe pas
			
			enemy_pirate.scale.x = 0.2
			enemy_pirate.scale.y = 0.18
			
			$EnemyPirateSpawn.add_child(enemy_pirate)	
			
			if $Player.global_position.x >= enemy_pirate.global_position.x:
				enemy_pirate.flipSprite(false)
			else:
				enemy_pirate.flipSprite(true)
			
			print("Position X Player : ", $Player.global_position.x)
			print("Position X Enemy : ", enemy_pirate.global_position.x)
			
			Global.numberEnemy += 1
			print("spawnEnemyPirate")
		else:
			print("Erreur : Le noeud parent 'EnemyPirateSpawn' n'a pas été trouvé.")

	else:
		print("Limite d'enemy pirate atteint")
		
	$Scene/PirateShipEnemy.changeRandomX()



func _on_player_projectile(pos: Variant) -> void:
	var projectile = projectile_scene.instantiate()
	if projectile != null: # Vérication pour éviter les erreurs si le noeud parent n'existe pas
		$Projectiles.add_child(projectile)
		projectile.flipSprite(flipDirectionProjectile)
		projectile.position = pos
		

func _on_player_projectile_flip_direction(flip: Variant) -> void:
	flipDirectionProjectile = flip


func _on_pirate_ship_enemy_charged_ship_enemy() -> void:	
	$PirateEnemyTimer.stop()
	
	changeScene = true
	
	useGravity.emit(false)


func _on_health_boss_death_boss() -> void:
	$HealthBoss.hide()
	deathFirstBoss = true
	changeScene = true
	useGravity.emit(false)
