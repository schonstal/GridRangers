extends Sprite

export var energy_cost = 4

func activate_at(position):
  for x in Game.scene.grid.width:
    var tile = Game.scene.grid.get_tile(Vector2(x, position.y))
    if tile.player == false:
      tile.hurt(1)

  Game.scene.grid.check_matches()
