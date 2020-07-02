extends Node2D

onready var done_button = $DoneButton
onready var window_appear = $WindowAppear

func _ready():
  EventBus.connect("spawn_shop", self, "_on_spawn_shop")
  done_button.connect("pressed", self, "_on_DoneButton_pressed")

func _on_DoneButton_pressed():
  EventBus.emit_signal("tutorial_complete")
  window_appear.disappear()

func _on_spawn_shop():
  print("hello")
  if Game.tutorial:
    window_appear.call_deferred("appear")
