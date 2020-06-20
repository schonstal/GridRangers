extends Node

onready var tile = $'..'
onready var animation = $'../AnimationPlayer'

func _ready():
  tile.connect("hurt", self, "_on_hurt")

func _on_hurt():
  if tile.health < 2:
    animation.play("Break")
    tile.traversable = true
