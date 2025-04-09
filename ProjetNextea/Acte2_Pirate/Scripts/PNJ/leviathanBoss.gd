extends Node2D

var startFight := false
var hit := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hit:
		$LeviathanSprite.play("idle")
	



func _on_leviathan_sprite_animation_finished() -> void:
	hit = false




func _on_area_2d_active_canon_attaque(leftCote: Variant) -> void:
	if leftCote:
		print("HitLeftEye")
		Global.healthBoss -= 10
		hit = true
		$LeviathanSprite.play("hitEyeGauche")
	else:
		print("HitRightEye")
		Global.healthBoss -= 5
		hit = true
		$LeviathanSprite.play("hitEyeDroite")


func _on_ship_boss_start_boss_fight_leviathan() -> void:
	startFight = true
