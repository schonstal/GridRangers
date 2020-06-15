extends Node

var scene:Node

var tile_selected = Vector2(-1, -1)

func _ready():
  randomize()
  scene = $'../Gameplay'
