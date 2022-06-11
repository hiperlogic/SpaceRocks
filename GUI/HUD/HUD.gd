extends CanvasLayer


signal start_game

onready var lives_counter = [
	$MarginContainer/HBoxContainer/LivesCounter/L1,
	$MarginContainer/HBoxContainer/LivesCounter/L2,
	$MarginContainer/HBoxContainer/LivesCounter/L3
]


func show_message(message):
	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()
	
func update_score(value):
	$MarginContainer/HBoxContainer/ScoreLabel.text = str(value)
	
func update_lives(value):
	for item in range(3):
		lives_counter[item].visible = value > item

func game_over():
	show_message("Game Over")
	yield($MessageLabel, "timeout")
	$StartButton.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
	pass # Replace with function body.


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	$MessageLabel.text = ''
	pass # Replace with function body.
