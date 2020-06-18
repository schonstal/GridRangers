extends Node

onready var tile = $'..'

func _ready():
  tile.connect("matched", self, "_on_matched")

func _on_matched():
  EventBus.emit_signal("coin_collected")
