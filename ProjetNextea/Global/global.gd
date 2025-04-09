extends Node

var timeScore := 0

var collectible := 0
var maxCollectible := 0
var numberCollectedCollectible := 0
var maxAllCollectible := 0

var health := 3
var maxHealth := 3

var healthBoss := 100

var numberEnemy := 0
var canInteract := false

var sceneToRespawn := ""

@onready var spriteProjectilePlayer = load("res://Global/ImportImage/ParDefaut/Projectile.png")
