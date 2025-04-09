extends MarginContainer

@onready var dialogBox = self
@onready var label = $MarginContainerForText/Label
@onready var timer = $TimerDisplayLetters

var maxWidthText := 350
var text := ""
var letter_index := 0

var letter_time := 0.03
var space_time := 0.06
var punctuation_time := 0.2

signal finishText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func displayText(textToDisplay: String):
	text = textToDisplay
	label.text = textToDisplay
	
	await dialogBox.resized
	dialogBox.custom_minimum_size.x = min(dialogBox.size.x, maxWidthText)
	
	if dialogBox.size.x > maxWidthText:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await dialogBox.resized 
		dialogBox.custom_minimum_size.y = dialogBox.size.y
		
	dialogBox.global_position.x -= dialogBox.size.x / 2
	dialogBox.global_position.y -= dialogBox.size.y + 24
	
	label.text = ""
	displayLetter()
	
func displayLetter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finishText.emit()
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_timer_display_letters_timeout() -> void:
	displayLetter()
