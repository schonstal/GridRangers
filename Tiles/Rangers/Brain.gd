extends Node

onready var tile = $'..'

func _ready():
  tile.connect("swapped", self, "_on_swapped")
  tile.connect("matched", self, "_on_matched")

func _on_matched():
  EventBus.emit_signal("player_died", self)

func _on_swapped():
  if Game.scene.phase == Game.PHASE_PLAYER:
    var other_tile = Game.scene.grid.get_tile(tile.previous_grid_position)
    if other_tile.enemy:
      other_tile.hurt(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
