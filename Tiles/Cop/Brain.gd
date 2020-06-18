extends Node

onready var animation = $'../Sprite/AnimationPlayer'
onready var tile = $'../'

var sleeping = true

func _ready():
  animation.connect("animation_finished", self, "_on_Animation_finished")
  tile.connect("matched", self, "_on_matched")

  EventBus.emit_signal("enemy_spawned", self)

func execute_turn():
  if sleeping:
    sleeping = false
    animation.play("WakeUp")
  else:
    print("attacking")

func _on_matched():
  animation.play("Die")
  EventBus.emit_signal("enemy_died", self)

func _on_Animation_finished(name):
  if name == "WakeUp":
    EventBus.emit_signal("turn_complete")
    animation.play("Idle")
