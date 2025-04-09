extends CharacterBody2D

@export var talkLines: Array[String]

@export var bossTalkLines: Array[String] = [
	"Tu es enfin arrivé Nextea !",
	"Alors, le marché est conclu ?",
	"Car je commence à avoir faim, moi et... moi-même...",
	"Comment ça ? Tu refuse ?!",
	"Tu m'avais promis une tarte...",
	"Les gars !! Il ne veut pas nous faire à manger !!!",
]

@onready var positionTextDialog := Vector2(global_position.x + 10, global_position.y - 10)
@onready var positionTextDialogBoss = Vector2($ZoneTextDialog.global_position.x, $ZoneTextDialog.global_position.y)


func playIdleAnimation():
	$GouluSprite.play("idle")

func _on_area_to_talk_start_dialog() -> void:
	$GouluSprite.play("talking")
	DialogManager.start_dialog(positionTextDialog, talkLines, Vector2(0.3,0.3))
	print("Talking with Goulu")

func startBossDialog() -> void:
	$AreaToTalk.hide()
	$AreaToTalk/CollisionTalk.disabled = true
	$GouluSprite.play("talking")
	DialogManager.start_dialog(positionTextDialog, bossTalkLines, Vector2(0.4,0.4))
	print("Talking with Goulu (Auto Boss)")
