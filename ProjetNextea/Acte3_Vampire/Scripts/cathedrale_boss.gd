extends Node2D

@export var enemy_adepte_scene :PackedScene 
@export var projectile_scene :PackedScene 
@export var musicCathedraleBoss :AudioStreamMP3
@export var targetPositionMusicPlaybackBeginAutoDialog := 6.00
@export var targetPositionMusicPlaybackBeginBossFight := 67.75
@export var nameBoss := "Lucius Kane, Le Demi-Dieu Vampirique"
@export var targetHealthToSecondPhaseForBoss := 50.0


var flipDirectionProjectile := false
var changeScene := false
var beginAutoDialog := false
var beginBossFight := false

signal positionPlayer
signal useGravity
signal changeSpriteFloorAlly
signal startBossFight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.health = 3
	Global.numberEnemy = 0
	
	get_tree().call_group('UI', 'set_health', Global.health)
	
	positionPlayer.emit(Vector2(675, 620))
	$MusicAudio.stream = musicCathedraleBoss
	$MusicAudio.play()
	$HealthBoss.hide()
	$Player.jump = -700
	$Player.speed = 350


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $MusicAudio.playing:
		# positionMusicPlayback va récupérer le temps écoulé de la lecture
		var positionMusicPlayback = $MusicAudio.get_playback_position()
		
		if positionMusicPlayback >= targetPositionMusicPlaybackBeginAutoDialog and !beginAutoDialog:
			beginAutoDialog = true
			$LuciusKane.startBossDialog()
			$TimerAutoDialog.start()
		
		# Si on arrive à un moment précis de la musique alors on déclenche la cinématique
		if positionMusicPlayback >= targetPositionMusicPlaybackBeginBossFight and !beginBossFight:
			beginBossFight = true
			_start_boss_fight()
	
	if $Player.global_position.x < $LuciusKane.global_position.x:
		$LuciusKane.flipSprite(false)
	else:
		$LuciusKane.flipSprite(true)
		
func _start_boss_fight() -> void:
	$HealthBoss.show()
	$HealthBoss.setNameBoss(nameBoss)
	$HealthBoss.setMaxHelthBoss(100)
	
	$TimerAutoDialog.stop()
	DialogManager._destroy_text_box()
	
	startBossFight.emit()
	
	if Global.health < Global.maxHealth : 
		Global.health = Global.maxHealth
		get_tree().call_group('UI', 'set_health', Global.health)


func _on_player_projectile(pos: Variant) -> void:
	var projectile = projectile_scene.instantiate()
	if projectile != null: # Vérication pour éviter les erreurs si le noeud parent n'existe pas
		$Projectiles.add_child(projectile)
		projectile.flipSprite(flipDirectionProjectile)
		projectile.position = pos

func _on_player_projectile_flip_direction(flip: Variant) -> void:
	flipDirectionProjectile = flip




func _on_health_boss_death_boss() -> void:
	$HealthBoss.hide()
	$TimerEndGame.start()
	


func _on_timer_auto_dialog_timeout() -> void:
	DialogManager._on_auto_interact_timeout()


func _on_timer_end_game_timeout() -> void:
	get_tree().change_scene_to_file("res://Acte1_Foret/Scenes/Tower.tscn")
