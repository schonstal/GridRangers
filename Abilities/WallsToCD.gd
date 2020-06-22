extends Node

var cd_tile = preload("res://Tiles/Coin/CoinTile.tscn")

export var energy_cost = 6

func activate_at(position):
  for x in Game.scene.grid.width:
    for y in Game.scene.grid.height:
      var tile = Game.scene.grid.get_tile(Vector2(x, y))
      if tile.type == "Wall":
        tile.queue_free()
        var instance = cd_tile.instance()
        instance.set_grid_position(Vector2(x, y))
        Game.scene.grid.tiles[x][y] = instance
        instance.position = Game.scene.grid.grid_to_pixel(instance.grid_position)
        instance.scale.x = 0.8
        instance.scale.y = 0.8
        Game.scene.grid.add_child(instance)

  Game.scene.grid.check_matches()
