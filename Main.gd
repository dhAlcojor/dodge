extends Node

export (PackedScene) var Mob
var score
var game_started = false
var high_scores = []


# Called when the node enters the scene tree for the first time.
func _ready():
  load_high_scores()
  randomize()
  new_game()


func _input(event: InputEvent) -> void:
  if event is InputEventScreenTouch and event.is_pressed() and !game_started:
    new_game()


func game_over():
  save_high_scores()
  $HUD.hide_score()
  $HUD.show_high_scores(high_scores)
  $ScoreTimer.stop()
  $MobTimer.stop()
  yield($HUD.show_game_over(), 'completed') # Wait until show_game_over() has finished
  get_tree().call_group('mobs', 'queue_free') # Remove all enemies
  $Music.stop()
  $DeathSound.play()
  game_started = false


func new_game():
  score = 0
  $HUD.show_score()
  $Player.start($StartPosition.position)
  $StartTimer.start()
  game_started = true
  $HUD.update_score(score)
  $HUD.hide_instructions()
  $HUD.hide_high_scores()
  $HUD.show_message('Get Ready')
  $Music.play()


func _on_MobTimer_timeout():
  # Choose a random location on Path2D.
  $MobPath/MobSpawnLocation.offset = randi()
  # Create a Mob instance and add it to the scene.
  var mob = Mob.instance()
  add_child(mob)
  # Set the mob's direction perpendicular to the path direction.
  var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
  # Set the mob's position to a random location.
  mob.position = $MobPath/MobSpawnLocation.position
  # Add some randomness to the direction.
  direction += rand_range(-PI / 4, PI / 4)
  mob.rotation = direction
  # Set the velocity (speed & direction).
  mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
  mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
  score += 1
  $HUD.update_score(score)


func _on_StartTimer_timeout():
  $MobTimer.start()
  $ScoreTimer.start()


func save_high_scores():
  print('high scores before:', high_scores, score)
  if high_scores.has(score): # If the new score is already a high score, do nothing
    return

  high_scores.append(score)
  high_scores.sort()
  high_scores.invert()

  # We're only storing the top 3 scores, for now
  if high_scores.size() > 3:
    high_scores.pop_back()

  print('high scores after: ', high_scores)

  var save_game = File.new()
  save_game.open('user://savegame.save', File.WRITE)
  save_game.store_line(to_json(high_scores))
  save_game.close()

func load_high_scores():
  var save_game = File.new()
  save_game.open('user://savegame.save', File.READ)
  high_scores = parse_json(save_game.get_line())
  if high_scores == null:
    high_scores = []

  print('high scores: ', high_scores)

  save_game.close()
