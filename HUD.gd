extends CanvasLayer


func _on_MessageTimer_timeout() -> void:
  $Message.hide()


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


func hide_instructions():
  $Instructions.hide()


func show_high_scores(high_scores: Array):
  var high_scores_text = ''
  for score in high_scores:
    high_scores_text += str(score) + "\n"

  $HighScoresLabel.text = high_scores_text

  $HighScoresTitle.show()
  $HighScoresLabel.show()


func hide_high_scores():
  $HighScoresTitle.hide()
  $HighScoresLabel.hide()


func hide_score():
  $ScoreLabel.hide()


func show_score():
  $ScoreLabel.show()
