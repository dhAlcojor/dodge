extends Node


func _input(event):
  if event is InputEventScreenTouch and event.is_pressed():
    get_tree().change_scene("res://Main.tscn")
