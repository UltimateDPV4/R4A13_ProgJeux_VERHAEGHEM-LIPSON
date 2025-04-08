extends Node2D

@export var enemy_goulu_scene :PackedScene 
@export var projectile_scene :PackedScene 
@export var musicTowerExploration :AudioStreamMP3
@export var musicTowerCinematic :AudioStreamMP3
@export var musicTowerBoss :AudioStreamMP3
@export var nameBoss := "Goulu, Le Roi Gourmand"

var flipDirectionProjectile := false
var beginCinematic := false
var placeCorrectyGouluBoss := false

signal positionPlayer(float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.numberCollectedCollectible += Global.collectible
	Global.collectible = 0
	Global.maxCollectible = 4
	Global.maxAllCollectible += Global.maxCollectible
	Global.health = 3
	Global.numberEnemy = 0
	
	get_tree().call_group('UI', 'set_health', Global.health)
	
	for groupGoulu in $SpawnGouluForBoss.get_children():
		groupGoulu.hide()
		
		if groupGoulu is Area2D:
			for collision_shape in groupGoulu.get_children():
				if collision_shape is CollisionShape2D or collision_shape is CollisionPolygon2D:
					collision_shape.set_deferred("disabled", true)
		
	$HealthBoss.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (beginCinematic):
		$Player.speed = 0
		$Player.jump = 0
		
		for goulu in $Cinematic/SpawnGouluCinematic.get_children():
			goulu.global_position.x -= 5 * delta
			if (goulu.position.x <= -1075):
				goulu.global_position.y += 10 * delta
				goulu.rotation -= 1.5 * delta
		
		if ($Cinematic/SpawnGouluCinematic.get_children().size() >= 2):
			if ($Cinematic/CameraCinematic.position.x > 3700.0):
				$Cinematic/CameraCinematic.position.x -= 15 * delta
			else:
				$Cinematic/CameraCinematic.position.x = 3700.0	
		
		var positionMusicPlayback = $Player/MusicAudio.get_playback_position()
		
		if (positionMusicPlayback >= 40.0 and $Cinematic/CameraCinematic.zoom != Vector2(2.5,2.5)):
			$Cinematic/CameraCinematic.zoom.x -= 0.03125
			$Cinematic/CameraCinematic.zoom.y -= 0.03125
					
		if (positionMusicPlayback >= 60.0 and $Cinematic/Goulu.position.y > -16900 and !placeCorrectyGouluBoss):
			$Cinematic/Goulu.position.y -= 150 * delta
			$Cinematic/Goulu.rotation -= 2 * delta
			if ($Cinematic/Goulu.position.y <= -16900):
				$Cinematic/Goulu.position.y = -16860
				placeCorrectyGouluBoss = true
		if ($Cinematic/Goulu.position.y < -16700 and placeCorrectyGouluBoss):
			$Cinematic/Goulu.position.y += 150 * delta
			$Cinematic/Goulu.rotation -= 5 * delta
			if ($Cinematic/Goulu.position.y >= -16700):
				$Cinematic/Goulu.position.y = -16700
				$Cinematic/Goulu.rotation = 0
				
				$Cinematic/Goulu.startBossDialog()
				$Cinematic/TimerAutoDialog.start()
			
		if (positionMusicPlayback >= 94.0 or $Player/Camera2D.enabled == true):
			$Player.speed = 150
			$Player.jump = -300
			
			$Cinematic/TimerAutoDialog.stop()
			$Cinematic/CameraCinematic.enabled = false
			$Player/Camera2D.enabled = true
			
			$TileMap/TileMapLayer6.hide()
			$TileMap/TileMapLayer6/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
			
			$Player/MusicAudio.stream = musicTowerBoss
			$Player/MusicAudio.play()
			
			for groupGoulu in $SpawnGouluForBoss.get_children():
				groupGoulu.show()
		
				if groupGoulu is Area2D:
					for collision_shape in groupGoulu.get_children():
						if collision_shape is CollisionShape2D or collision_shape is CollisionPolygon2D:
							collision_shape.set_deferred("disabled", false)
			
	else:
		$Player.speed = 150
		$Player.jump = -300
		

func _on_begin_cinematic_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$Cinematic/CameraCinematic.enabled = true
		$Player/Camera2D.enabled = false
		
		$Cinematic/Hammer.play("default")
		$Cinematic/TimerSpawnGouluCinematic.start()
		
		$Player/MusicAudio.stream = musicTowerCinematic
		$Player/MusicAudio.volume_db = 0
		$Player/MusicAudio.play()
		$Cinematic/BeginCinematic/CollisionShape2D.set_deferred("disabled", true)
		beginCinematic = true


func _on_end_cinematic_body_entered(body: Node2D) -> void:
	beginCinematic = false
	for gouluDeco in $Cinematic/SpawnGouluCinematic.get_children():
		gouluDeco.queue_free()


func _on_timer_spawn_goulu_cinematic_timeout() -> void:
	var enemy_goulu = enemy_goulu_scene.instantiate()

	if enemy_goulu != null: # Vérication pour éviter les erreurs si le noeud parent n'existe pas
			
		enemy_goulu.scale.x = 0.4
		enemy_goulu.scale.y = 0.4
		enemy_goulu.playIdleAnimation()
		enemy_goulu.set_z_index(-3)
			
		$Cinematic/SpawnGouluCinematic.add_child(enemy_goulu)	
			
		print("spawnEnemyGouluCinematic")


func _on_timer_auto_dialog_timeout() -> void:
	DialogManager._on_auto_interact_timeout()


func _on_next_level_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		get_tree().change_scene_to_file("res://Acte2_Pirate/Scenes/villagePirate.tscn")


func _on_player_projectile(pos: Variant) -> void:
	var projectile = projectile_scene.instantiate()
	if projectile != null: # Vérication pour éviter les erreurs si le noeud parent n'existe pas
		projectile.scale = Vector2(0.2, 0.2)
		projectile.speed = 200
		$Projectiles.add_child(projectile)
		projectile.flipSprite(flipDirectionProjectile)
		projectile.position = pos


func _on_player_projectile_flip_direction(flip: Variant) -> void:
	flipDirectionProjectile = flip


func _on_change_music_exploration_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		$Player/MusicAudio.stream = musicTowerExploration
		$Player/MusicAudio.volume_db = 0
		$Player/MusicAudio.play()
