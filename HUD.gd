extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _on_MessageTimer_timeout() -> void:
  $Message.hide()


#func _on_StartButton_pressed() -> void:
  #$StartButton.hide()
  #emit_signal('start_game')


func show_message(text):
  $Message.text = text
  $Message.show()
  $MessageTimer.start()


func show_game_over():
  show_message('Game Over')

  # Wait until the MessageTimer has counted down
  yield($MessageTimer, 'timeout')

  $Instructions.show()

  # Make a one-shot timer and wait for it to finish
  yield(get_tree().create_timer(1), 'timeout')


func update_score(score):
  $ScoreLabel.text = str(score)


func hideInstructions():
  $Instructions.hide()
