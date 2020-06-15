extends Node2D

export var width = 24
export var height = 24

export(Array,Resource) var tile_scenes = []

var tiles = []
var tile_size = 128

var selected_tile = null
var swap_intent = null
var dragging = false
var matching = false

onready var background = $Background
onready var match_timer = $MatchTimer

func _ready():
  randomize()
  spawn_tiles()
  background.region_rect = Rect2(0, 0, width * 128, height * 128)
  position.x = 1920 / 2 - width * tile_size / 2

  match_timer.connect("timeout", self, "_on_MatchTimer_timeout")

func spawn_tiles():
  for x in width:
    tiles.append([])
    for y in height:
      tiles[x].append(null)
      spawn_tile(x, y)

func spawn_tile(x, y):
  var shuffled = tile_scenes.duplicate()
  shuffled.shuffle()

  var instance = null

  while shuffled.size() > 0:
    var scene = shuffled.pop_front()
    instance = scene.instance()
    instance.set_grid_position(Vector2(x, y))
    tiles[x][y] = instance
    if !match(x, y, false):
      break

  instance.position = grid_to_pixel(instance.grid_position)
  instance.scale.x = 0.8
  instance.scale.y = 0.8

  #call_deferred("add_child", instance)
  add_child(instance)

  return instance

func execute_match():
  var matches = 0
  for x in width:
    for y in height:
      if tiles[x][y] != null && tiles[x][y].matched:
        tiles[x][y] = null
        matches += 1

  EventBus.emit_signal("blur_chromatic", log(matches - 1), 2.0)
  match_timer.start()
  matching = true

func collapse_board():
  matching = false
  for x in width:
    var tiles_shifted = 0
    for y in range(height - 1, -1, -1):
      if tiles[x][y] == null:
        for i in range(y - 1, -1, -1):
          if tiles[x][i] != null:
            tiles[x][i].set_grid_position(Vector2(x, y))
            tiles[x][i].move_to(grid_to_pixel(tiles[x][i].grid_position))
            tiles[x][y] = tiles[x][i]
            tiles[x][i] = null
            tiles_shifted += 1
            break

    var empty_spaces = height - tiles_shifted - 1
    for y in range(0, height):
      if tiles[x][y] == null:
        tiles[x][y] = spawn_tile(x, y)
        tiles[x][y].position = grid_to_pixel(Vector2(x, -empty_spaces))
        tiles[x][y].move_to(grid_to_pixel(Vector2(x, y)))
        empty_spaces -= 1

func match(x, y, mark):
  var tile = tiles[x][y]
  var matched = false

  if x > 1:
    var first = tiles[x - 1][y]
    var second = tiles[x - 2][y]
    matched = check_match(tile, first, second, mark)

  if y > 1:
    var first = tiles[x][y - 1]
    var second = tiles[x][y - 2]
    matched = check_match(tile, first, second, mark) || matched

  return matched

func check_match(a, b, c, mark):
  if a != null && b != null && c != null && a.type == b.type && b.type == c.type:
    if mark:
      a.match()
      b.match()
      c.match()
    return true

  return false

func pixel_to_grid(pixel_position):
  var local_position = pixel_position - global_position

  if local_position.x < 0 || local_position.y < 0:
    return null
  if local_position.x > tile_size * width || local_position.y > tile_size * height:
    return null

  var grid_position = local_position / tile_size

  grid_position.x = int(grid_position.x)
  grid_position.y = int(grid_position.y)

  return grid_position

func mouse_to_grid():
  var mouse_position = get_viewport().get_mouse_position()
  return pixel_to_grid(mouse_position)

func grab_tile(grid_position):
  selected_tile = tiles[grid_position.x][grid_position.y]
  selected_tile.start_drag()

func swap_tile(grid_position):
  if selected_tile == null:
    return

  selected_tile.stop_drag()

  if !legal_swap(selected_tile.grid_position, grid_position):
    selected_tile.position.x = tile_size * selected_tile.grid_position.x + tile_size / 2
    selected_tile.position.y = tile_size * selected_tile.grid_position.y + tile_size / 2
    selected_tile = null
    return

  var other = tiles[grid_position.x][grid_position.y]

  tiles[grid_position.x][grid_position.y] = selected_tile
  tiles[selected_tile.grid_position.x][selected_tile.grid_position.y] = other

  selected_tile.position.x = tile_size * grid_position.x + tile_size / 2
  selected_tile.position.y = tile_size * grid_position.y + tile_size / 2

  other.position.x = tile_size * selected_tile.grid_position.x + tile_size / 2
  other.position.y = tile_size * selected_tile.grid_position.y + tile_size / 2
  other.set_grid_position(selected_tile.grid_position)

  selected_tile.set_grid_position(grid_position)

  selected_tile = null

  if evaluate_matches() > 0:
    execute_match()

func evaluate_matches():
  var matches = 0
  for x in width:
    for y in height:
      if self.match(x, y, true):
        matches += 1

  return matches

func grid_to_pixel(grid_position):
  return Vector2(
      tile_size * grid_position.x + tile_size / 2,
      tile_size * grid_position.y + tile_size / 2
    )

func legal_swap(start, end):
  if start == null || end == null:
    return false

  var difference = start - end
  return abs(difference.x) + abs(difference.y) == 1

func _input(event):
  if matching:
    return

  if event is InputEventMouseButton:
    var location = mouse_to_grid()

    if event.button_index == BUTTON_LEFT && event.pressed && !dragging:
      if location == null:
        swap_intent = null
        dragging = false
        if selected_tile != null:
          swap_tile(selected_tile.grid_position)
        return

      grab_tile(location)
      dragging = true
    elif event.button_index == BUTTON_LEFT and !event.pressed && dragging:
      swap_tile(swap_intent)
      dragging = false
      swap_intent = null

  if event is InputEventMouseMotion:
    if dragging && selected_tile != null:
      var location = pixel_to_grid(selected_tile.global_position)

      if swap_intent != location:
        if swap_intent != null && location != swap_intent:
          tiles[swap_intent.x][swap_intent.y].move_to(grid_to_pixel(tiles[swap_intent.x][swap_intent.y].grid_position))
        if legal_swap(selected_tile.grid_position, location) && location != selected_tile.grid_position:
          swap_intent = location
          tiles[swap_intent.x][swap_intent.y].move_to(grid_to_pixel(selected_tile.grid_position))
        else:
          swap_intent = null

func _on_MatchTimer_timeout():
  collapse_board()
