extends Area2D

@export var speed := 750
@export var projectileEnemy := false
@onready var sprite := $Projectile

var flipping := false
var goToCible := false

signal collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("projectile")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!projectileEnemy):
		if (!flipping):
			position.x -= speed * delta
		else:
			position.x += speed * delta
	else:
		if (goToCible):
			position += transform.x * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if(!projectileEnemy):
		if(area.is_in_group("enemy")):
			print("Détection Enemy")
			Global.numberEnemy -= 1
			queue_free()
		if(area.is_in_group("boss")):
			print("Détection Boss")
			Global.healthBoss -= 5
			queue_free()



func _on_body_entered(body: Node2D) -> void:
	if !projectileEnemy :
		if(body.is_in_group("enemy")):
			print("Détection Enemy")
			Global.numberEnemy -= 1
			body.queue_free()
			queue_free()
		if(body.is_in_group("boss")):
			print("Détection Boss")
			Global.healthBoss -= 2.5
			queue_free()

				
	if projectileEnemy :
		if body.is_in_group("player") && $CollisionShape2D.disabled == false:
			print("Collision Projectile Nextea")
			Global.health -= 1
			get_tree().call_group('UI', 'set_health', Global.health)
			if Global.health <= 0:
				get_tree().change_scene_to_file("res://Global/Scenes/UI/game_over_ui.tscn")


func flipSprite(flip) -> void:
	flipping = flip
	sprite.flip_h = flip


func setRotation(rotation: float):
	rotate(rotation)
	flipSprite(true)
	goToCible = true
