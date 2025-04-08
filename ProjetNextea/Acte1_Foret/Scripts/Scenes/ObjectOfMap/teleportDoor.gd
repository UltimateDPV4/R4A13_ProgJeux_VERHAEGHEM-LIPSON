extends Node2D

@onready var player = owner.get_parent().find_child("Player")

var spawn1 := Vector2(0,0)
var spawn2 := Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn1 = $spawn1.global_position
	spawn2 = $spawn2.global_position
	print("Spawn1 : ", spawn1, " / Spawn2 : ", spawn2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_1_teleport_player() -> void:
	print("Teleport Player")
	player.global_position = spawn2


func _on_spawn_2_teleport_player() -> void:
	print("Teleport Player")
	player.global_position = spawn1
