extends Sprite

export var energy_cost = 6

func activate_at(position):
  print("activating")
  for y in Game.scene.grid.height:
    var tile = Game.scene.grid.get_tile(Vector2(position.x, y))
    if tile.player == false:
      tile.hurt(1)

  Game.scene.grid.check_matches()
