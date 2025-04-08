extends Node

@onready var textBoxScene = preload("res://Global/Scenes/text_dialog.tscn")

var dialogLines: Array[String] = []
var currentLineIndex := 0

var textBox
var textBoxPosition: Vector2
var textBoxScale: Vector2

var dialogActive := false
var canNextLine := false


func start_dialog(position: Vector2, lines: Array[String], scale: Vector2):
	if dialogActive:
		return
	dialogLines = lines
	textBoxPosition = position
	textBoxScale = scale
	showTextBox()
	dialogActive = true


func showTextBox():
	textBox = textBoxScene.instantiate()
	textBox.finishText.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(textBox)
	textBox.global_position = textBoxPosition
	textBox.scale = textBoxScale
	textBox.displayText(dialogLines[currentLineIndex])
	canNextLine = false

func _on_text_box_finished_displaying():
	canNextLine = true

func _on_auto_interact_timeout():
	# Simuler l'appui sur le bouton d'interaction
	if dialogActive and canNextLine:
		_destroy_text_box()
		currentLineIndex += 1
		if currentLineIndex >= dialogLines.size():
			dialogActive = false
			currentLineIndex = 0
			return
		showTextBox()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction") and dialogActive and canNextLine:
		_destroy_text_box()
		currentLineIndex += 1
		if currentLineIndex >= dialogLines.size():
			dialogActive = false
			currentLineIndex = 0
			return
		showTextBox()
		
func _destroy_text_box():
	if(textBox != null):
		textBox.queue_free()
