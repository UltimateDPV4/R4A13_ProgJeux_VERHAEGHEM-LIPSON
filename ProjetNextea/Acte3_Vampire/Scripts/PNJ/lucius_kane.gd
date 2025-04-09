extends CharacterBody2D

@export var talkLines: Array[String]
@export var bossTalkLines: Array[String] = [
	"Oh oh~ mais ne serait-ce pas notre cher Nextea ?",
	"Tu es venu pour voir mon ascension...",
	"Non...",
	"Non. Non. Non.",
	"Tu ne le pourras pas, Nextea.",
	"Malheureusement pour toi, il me manque une âme.",
	"Mais, heureusement pour moi...",
	"cette dernière est venue à point nommé.",
	"Nextea...",
	"je t'ai toujours adoré ! Alors, je te le demande gentiment :",
	"Laisse-toi mourir, pour la naissance d'un nouveau dieu...",
	"Laisse-toi mourir ...",
	"pour Lucius Kane ! Ton futur protecteur."
]

@onready var positionTextDialog = Vector2(global_position.x - 10, global_position.y - 10)
@onready var positionTextDialogBoss = Vector2($ZoneTextDialog.global_position.x, $ZoneTextDialog.global_position.y)

@onready var player = owner.get_parent().find_child("Player")
@onready var sprite = $LuciusKaneSprite
var talkedVille := false

signal startBossFight

func _ready() -> void:
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if talkedVille:
		if !DialogManager.dialogActive:
			$LuciusKaneSprite.play("teleport")
			set_physics_process(false)
			$CollisionShape2D.disabled = true
			talkedVille = false


func _on_area_to_talk_start_dialog() -> void:
	sprite.play("talking")
	talkedVille = true
	DialogManager.start_dialog(positionTextDialog, talkLines, Vector2(0.4, 0.4))
	print("Talking with Lucius Kane")

func startBossDialog() -> void:
	$AreaToTalk.hide()
	$AreaToTalk/CollisionTalk.disabled = true
	sprite.play("talking")
	DialogManager.start_dialog(positionTextDialogBoss, bossTalkLines, Vector2(1.0, 1.0))
	print("Talking with Lucius Kane (Auto Boss)")

func _on_cathedrale_boss_start_boss_fight() -> void:
	add_to_group("boss")
	startBossFight.emit()
	
func flipSprite(flip) -> void:
	$LuciusKaneSprite.flip_h = flip
	if flip:
		$LuciusKaneSprite/AttaqueMeleeLucius.flipSprite(false)
		$LuciusKaneSprite/AttaqueMeleeLucius.position.x = 40
	else:
		$LuciusKaneSprite/AttaqueMeleeLucius.flipSprite(true)
		$LuciusKaneSprite/AttaqueMeleeLucius.position.x = -40

func setAnimationBossFight(nameSprite) -> void:
	sprite.play(nameSprite)


func _on_health_boss_death_boss() -> void:
	set_physics_process(false)
	$CollisionShape2D.disabled = true
	hide()
