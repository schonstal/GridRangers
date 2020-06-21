extends Node

onready var tile = $'..'

func _ready():
  tile.connect("matched", self, "_on_matched")

func _on_matched():
  EventBus.emit_signal("energy_collected")
  #var point = tile.grid_position
  #var points_relative = [
  #    Vector2(point.x, point.y + 1),
  #    Vector2(point.x, point.y - 1),

  #    # Vector2(point.x - 1, point.y - 1),
  #    # Vector2(point.x - 1, point.y + 1),
  #    Vector2(point.x - 1, point.y),

  #    # Vector2(point.x + 1, point.y - 1),
  #    # Vector2(point.x + 1, point.y + 1),
  #    Vector2(point.x + 1, point.y)
  #  ]

  #for point in points_relative:
  #  var tile = Game.scene.grid.get_tile(point)
  #  if tile != null:
  #    tile.hurt(1)
