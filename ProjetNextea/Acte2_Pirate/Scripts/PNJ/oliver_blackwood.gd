extends CharacterBody2D

@export var talkLines: Array[String]

@export var bossTalkLines: Array[String] = [
	"Bien, j'espère que tu n'as pas trop le mal de mer.",
	"On devrais arriver d'ici quelques jours.",
	"On a un peu le temps de discuter alors !",
	"Tu connais les légendes urbaines de ces mers ?",
	"Apparament, un navire fantôme rôde...",
	"Des marins qui se sont fait avaler par un léviathan !",
	"Cela fait froid dans le dos...",
	"Je te rassure, je ne les ai jamais croisées.",
	"Après, comme je dis tout le temps :",
	"Face à la mort, on lâche son plus grand sourire !",
	"Hum... Qu'est-ce qu'il a ?",
	"Attend... Non...",
	"C'est le navire fantôme !"
]

@export var bossTalkLines2: Array[String] = [
	"Et bien, on a eu chaud !",
	"Merci encore pour ton aide.",
	"On devrait bientôt arriver à bon port.",
	"Je me souviendrais de toi, je te le promet.",
]

@onready var positionTextDialog := Vector2(global_position.x + 10, global_position.y - 10)
@onready var positionTextDialogBoss = Vector2($ZoneTextDialog.global_position.x, $ZoneTextDialog.global_position.y)

signal startTalking

func _ready() -> void:
	$OliverBlackwoodSprite.play("idle")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if (!DialogManager.dialogActive and not move_and_slide()):
		$OliverBlackwoodSprite.play("idle")


func _on_area_to_talk_start_dialog() -> void:
	$OliverBlackwoodSprite.play("talking")
	DialogManager.start_dialog(positionTextDialog, talkLines, Vector2(0.3,0.3))
	print("Talking with Oliver Blackwood")
	startTalking.emit()

func startBossDialog() -> void:
	$AreaToTalk.hide()
	$AreaToTalk/CollisionTalk.disabled = true
	$OliverBlackwoodSprite.play("talking")
	DialogManager.start_dialog(positionTextDialogBoss, bossTalkLines, Vector2(1,1))
	print("Talking with Oliver Blackwood ")

func startBossDialog2() -> void:
	$AreaToTalk.hide()
	$AreaToTalk/CollisionTalk.disabled = true
	$OliverBlackwoodSprite.play("talking")
	DialogManager.start_dialog(positionTextDialogBoss, bossTalkLines2, Vector2(1,1))
	print("Talking with Oliver Blackwood ")
