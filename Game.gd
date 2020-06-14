extends Node

var scene:Node

var tile_selected = Vector2(-1, -1)

func _ready():
  randomize()
  scene = $'../Gameplay'

func select_tile(x, y):
  tile_selected.x = x
  tile_selected.y = y

