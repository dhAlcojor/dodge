extends Node


func _ready():
  if OS.has_feature('Android'):
    var width = ProjectSettings.get_setting('display/window/size/width')
    var height = ProjectSettings.get_setting('display/window/size/height')
    get_tree().set_screen_stretch(
      SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(width, height), 1
    )


func _input(event):
  if event is InputEventScreenTouch and event.is_pressed():
    get_tree().change_scene("res://Main.tscn")
