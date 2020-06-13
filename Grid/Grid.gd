extends Node2D

export var width = 24
export var height = 24

export(Array,Resource) var tile_scenes = []

var tiles = []

var tile_size = 128

onready var background = $Background

func _ready():
  randomize()
  spawn_tiles()
  background.region_rect = Rect2(0, 0, width * 128, height * 128)
  position.x = 1920 / 2 - width * tile_size / 2

func spawn_tiles():
  for x in width:
    tiles.append([])
    for y in height:
      tiles[x].append(spawn_tile(x, y))

func spawn_tile(x,y):
  var shuffled = tile_scenes.duplicate()
  shuffled.shuffle()

  var instance = null

  while shuffled.size() > 0:
    var scene = shuffled.pop_front()
    instance = scene.instance()
    if !match_type(instance.type, x, y):
      break

  instance.position.x = tile_size * x + tile_size / 2
  instance.position.y = tile_size * y + tile_size / 2
  instance.scale.x = 0.8
  instance.scale.y = 0.8

  call_deferred("add_child", instance)

  return instance

func match_type(type, x, y):
  if x > 1:
    var first = tiles[x - 1][y]
    var second = tiles[x - 2][y]

    if first != null && second != null:
      if type == first.type && first.type == second.type:
        return true

  if y > 1:
    var first = tiles[x][y - 1]
    var second = tiles[x][y - 2]

    if first != null && second != null:
      if type == first.type && first.type == second.type:
        return true
