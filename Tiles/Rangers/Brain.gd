extends Node

onready var tile = $'..'

export var color = 'red'

func _ready():
  tile.connect("swapped", self, "_on_swapped")
  tile.connect("matched", self, "_on_matched")

func _on_matched():
  EventBus.emit_signal("player_died", color)

func _on_swapped(other_tile):
  if Game.scene.phase == Game.PHASE_PLAYER:
    if other_tile.enemy:
      other_tile.hurt(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
