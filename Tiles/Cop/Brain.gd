extends Node

onready var animation = $'../Sprite/AnimationPlayer'
onready var tile = $'../'

var sleeping = true

func _ready():
  animation.connect("animation_finished", self, "_on_Animation_finished")
  EventBus.connect("enemy_phase", self, "_on_enemy_phase")
  tile.connect("matched", self, "_on_matched")

func _on_matched():
  animation.play("Die")

func _on_Animation_finished(name):
  if name == "WakeUp":
    animation.play("Idle")

func _on_enemy_phase():
  if !sleeping:
    return

  sleeping = false
  animation.play("WakeUp")
