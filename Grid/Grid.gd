extends Node2D

export var width = 24
export var height = 24

export(Array,Resource) var tile_scenes = []

var tiles = []

var tile_size = 64

func _ready():
  randomize()
  spawn_tiles()

func spawn_tiles():
  for x in width:
    tiles.append([])
    for y in height:
      tiles[x].append(spawn_tile(x, y))

func spawn_tile(x,y):
  var shuffled = tile_scenes.duplicate()
  shuffled.shuffle()

  var scene = shuffled.pop_front()

  var instance = scene.instance()
  instance.position.x = tile_size * x
  instance.position.y = tile_size * y

  call_deferred("add_child", instance)

  return instance
