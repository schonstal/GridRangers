extends Node

onready var tile = $'..'

func _ready():
  tile.connect("hurt", self, "_on_hurt")

func _on_hurt():
  if tile.health < 2:
    tile.modulate = Color(1.0, 0.5, 0.5, 0.5)
    tile.traversable = true
    tile.player = true
