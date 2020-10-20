extends Area2D

signal hit

export var speed = 400
var screen_size
var target = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
  screen_size = get_viewport().size
  hide()


# Read the input to move the player
func _input(event):
  if event is InputEventScreenTouch and event.is_pressed():
    target = event.position


func _process(delta):
  var velocity = Vector2()

  # If the player is far enough from the point in the screen where the user clicked or touched
  # add velocity to the player
  if position.distance_to(target) > 10:
    velocity = target - position

  if velocity.length() > 0:
    velocity = velocity.normalized() * speed
    $AnimatedSprite.play()
  else:
    $AnimatedSprite.stop()

  position += velocity * delta
  position.x = clamp(position.x, 0, screen_size.x)
  position.y = clamp(position.y, 0, screen_size.y)

  if velocity.length() > 0:
    $AnimatedSprite.animation = 'walk'
    $AnimatedSprite.look_at(target)
    $AnimatedSprite.rotate(PI / 2)
  else:
    $AnimatedSprite.animation = 'up'


func _on_Player_body_entered(_body: Node):
  hide()
  emit_signal('hit')
  $CollisionShape2D.set_deferred('disabled', true)


# Initialize the player
func start(pos):
  position = pos
  target = pos
  $AnimatedSprite.rotation_degrees = 0
  show()
  $CollisionShape2D.disabled = false
