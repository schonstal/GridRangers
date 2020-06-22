extends Node

export var energy_cost = 6

func activate_at(point):
  var points_relative = PoolVector2Array([
    Vector2(point.x + 1, point.y),
    Vector2(point.x - 1, point.y),
    Vector2(point.x, point.y + 1),
    Vector2(point.x, point.y - 1)])

  for p in points_relative:
    var tile = Game.scene.grid.get_tile(p)
    if tile != null && tile.player == false:
      tile.hurt(1)

  Game.scene.grid.check_matches()
