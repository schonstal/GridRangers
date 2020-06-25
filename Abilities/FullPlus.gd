extends Node

func activate_at(position):
  for x in Game.scene.grid.width:
    for y in Game.scene.grid.height:
      if position.x == x || position.y == y:
        var tile = Game.scene.grid.get_tile(x, y)
        if tile.player == false:
          tile.hurt(1)

  Game.scene.grid.check_matches()
