extends Node2D

export var width = 24
export var height = 24

export(Array,Resource) var tile_scenes = []

var rangers = {
  'red': preload("res://Tiles/Rangers/RedRanger.tscn"),
  'blue': preload("res://Tiles/Rangers/BlueRanger.tscn"),
  'yellow': preload("res://Tiles/Rangers/YellowRanger.tscn")
}

var tiles = []
var tile_size = 128

var selected_tile = null
var swap_intent = null
var dragging = false
var respawn_enemies = false
var spawn_count = 0
var enemy_spawn_count = 0

onready var background = $Background
onready var match_timer = $MatchTimer
onready var collapse_timer = $CollapseTimer
onready var backdrop = $Backdrop
onready var fade_tween = $FadeTween
onready var sequence_timer = $SequenceTimer
onready var match_sound = $MatchSound
onready var swap_sound = $SwapSound

signal sequence_completed

func _ready():
  randomize()

  background.region_rect = Rect2(0, 0, width * 128, height * 128)
  position.x = 1920 / 2 - width * tile_size / 2

  Game.scene.disable_input()

  EventBus.connect("level_completed", self, "_on_level_completed")
  EventBus.connect("start_level", self, "_on_start_level")
  EventBus.connect("game_over", self, "_on_game_over")

  collapse_timer.connect("timeout", self, "_on_CollapseTimer_timeout")
  match_timer.connect("timeout", self, "_on_MatchTimer_timeout")

  create_empty_grid()
  call_deferred("populate_grid")

func _on_game_over():
  queue_free()

func get_tile(position):
  if outside_bounds(position):
    return null

  return tiles[position.x][position.y]

func outside_bounds(position):
  return position.x < 0 ||\
         position.y < 0 ||\
         position.x >= width ||\
         position.y >= height

func fade_in():
  #backdrop.modulate = Color(100, 100, 100, 1)
  fade_tween.interpolate_property(
    background,
    "fade",
    0.0,
    10.0,
    0.5,
    Tween.TRANS_LINEAR,
    Tween.EASE_OUT,
    2.0
   )
  fade_tween.start()
  yield(fade_tween, "tween_completed")
  emit_signal("sequence_completed")
  backdrop.modulate = Color(1, 1, 1, 1)

func fade_out():
  #backdrop.modulate = Color(100, 100, 100, 1)
  fade_tween.interpolate_property(
    background,
    "fade",
    8.0,
    0.0,
    0.5,
    Tween.TRANS_LINEAR,
    Tween.EASE_OUT,
    0.5
   )
  fade_tween.start()
  yield(fade_tween, "tween_completed")
  emit_signal("sequence_completed")

func populate_grid():
  respawn_enemies = false

  clear_grid()
  call_deferred("fade_in")
  yield(self, "sequence_completed")
  call_deferred("spawn_rangers")
  yield(self, "sequence_completed")
  call_deferred("spawn_enemies")
  yield(self, "sequence_completed")
  call_deferred("spawn_tiles")
  yield(self, "sequence_completed")
  call_deferred("teleport_rangers")
  yield(self, "sequence_completed")
  sequence_timer.start(0.25)
  yield(sequence_timer, "timeout")

  EventBus.emit_signal("change_phase", Game.PHASE_PLAYER)

  respawn_enemies = true

func clear_grid():
  for x in width:
    for y in height:
      if tiles[x][y] != null:
        tiles[x][y].queue_free()
      tiles[x][y] = null

func create_empty_grid():
  for x in width:
    tiles.append([])
    for y in height:
      tiles[x].append(null)

func spawn_enemies():
  var locations = []
  for x in width:
    for y in 5:
      locations.append(Vector2(x, y))

  locations.shuffle()

  var index = 0
  var enemy
  for count in Game.scene.current_level.standard:
    enemy = spawn_enemy(locations[index], "standard")
    while !enemy:
      enemy = spawn_enemy(locations[index], "standard")
      index += 1
    index += 1
  for count in Game.scene.current_level.moto:
    enemy = spawn_enemy(locations[index], "moto")
    while !enemy:
      enemy = spawn_enemy(locations[index], "moto")
      index += 1
    index += 1
  for count in Game.scene.current_level.shield:
    enemy = spawn_enemy(locations[index], "shield")
    while !enemy:
      enemy = spawn_enemy(locations[index], "shield")
      index += 1
    index += 1

  emit_signal("sequence_completed")

func spawn_enemy(position, type):
  enemy_spawn_count += 1
  var scene = Game.ENEMY_SCENES[type]
  var instance = scene.instance()
  instance.set_grid_position(position)
  tiles[position.x][position.y] = instance
  for x in width:
    for y in 5:
      if match(x, y, false):
        tiles[position.x][position.y] = null
        return false

  if Game.scene.current_level.alt_color_chance > 0 &&\
     enemy_spawn_count % Game.scene.current_level.alt_color_chance == 0:
    instance.alt_color = true
  instance.position = grid_to_pixel(instance.grid_position)
  instance.scale = Vector2(0, 0)
  call_deferred("add_child", instance)
  return instance

func spawn_rangers():
  var positions = {
    'red': Vector2(1, 6),
    'blue': Vector2(3, 6),
    'yellow': Vector2(5, 6)
  }
  for key in rangers:
    if !Game.scene.players_alive[key]:
      continue
    var instance = rangers[key].instance()
    instance.set_grid_position(positions[key])
    tiles[instance.grid_position.x][instance.grid_position.y] = instance
    instance.position = grid_to_pixel(instance.grid_position)
    instance.scale = Vector2(0.8, 0.8)
    Game.scene.players[key] = instance
    add_child(instance)

  emit_signal("sequence_completed")

func teleport_rangers():
  sequence_timer.start(0.2)
  yield(sequence_timer, "timeout")

  var ranger
  for key in Game.scene.players:
    ranger = Game.scene.players[key]
    if ranger != null && is_instance_valid(ranger):
      ranger.brain.teleport()
      EventBus.emit_signal("blur_chromatic", 2.0, 0.25)
      sequence_timer.start(0.25)
      yield(sequence_timer, "timeout")

  if ranger != null:
    yield(ranger.brain, "teleport_completed")

  emit_signal("sequence_completed")

func spawn_tiles():
  for y in height:
    var tile
    for x in width:
      if tiles[x][y] == null:
        tile = spawn_tile(x, y)
        tile.scale = Vector2(0, 0)
        tile.call_deferred("appear")
      else:
        tile = tiles[x][y]
        if !tile.player:
          tile.call_deferred("appear")

    sequence_timer.start(0.05)
    yield(sequence_timer, "timeout")

  emit_signal("sequence_completed")

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
  for x in width:
    for y in height:
      if tiles[x][y] != null && tiles[x][y].matched:
        tiles[x][y] = null
        Game.scene.combo += 1

  match_sound.play()
  var effect_strength = log(Game.scene.combo)
  EventBus.emit_signal("blur_chromatic", effect_strength, 2.0)
  match_timer.start()
  Game.scene.disable_input()

func collapse_board():
  collapse_timer.start()

  if Game.scene.phase == Game.PHASE_NONE:
    return

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
        if respawn_enemies:
          if get_enemies().size() == 0:
            if !spawn_enemy(Vector2(x, y), 'standard'):
              spawn_tile(x, y)
          else:
            spawn_count += 1
            var enemy_type = Game.scene.ai_director.enemy_spawn_type(spawn_count)
            if enemy_type == null:
              tiles[x][y] = spawn_tile(x, y)
            else:
              if !spawn_enemy(Vector2(x, y), enemy_type):
                tiles[x][y] = spawn_tile(x, y)
        else:
          tiles[x][y] = spawn_tile(x, y)
        tiles[x][y].position = grid_to_pixel(Vector2(x, -empty_spaces))
        tiles[x][y].scale = Vector2(0.8, 0.8)
        tiles[x][y].call_deferred("move_to", grid_to_pixel(Vector2(x, y)))
        empty_spaces -= 1

func match(x, y, mark):
  var tile = tiles[x][y]
  if tile == null:
    return
  var matched = false

  if x > 1:
    var first = tiles[x - 1][y]
    var second = tiles[x - 2][y]
    matched = check_match(tile, first, second, mark)

  if y > 1:
    var first = tiles[x][y - 1]
    var second = tiles[x][y - 2]
    matched = check_match(tile, first, second, mark) || matched

  if tiles[x][y].dead:
    Game.scene.combo += 1
    tiles[x][y].match()
    return true

  return matched

func check_match(a, b, c, mark = false):
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

func auto_swap(start, end):
  if !legal_swap(start, end):
    EventBus.emit_signal("turn_complete")
    return

  tiles[start.x][start.y].move_to(grid_to_pixel(tiles[end.x][end.y].grid_position))
  tiles[end.x][end.y].move_to(grid_to_pixel(tiles[start.x][start.y].grid_position))

  yield(tiles[end.x][end.y], "moved")

  swap_tiles(tiles[start.x][start.y], tiles[end.x][end.y])

func attempt_swap(grid_position):
  if selected_tile == null:
    return

  selected_tile.stop_drag()

  if !legal_swap(selected_tile.grid_position, grid_position):
    selected_tile.position = grid_to_pixel(selected_tile.grid_position)
    selected_tile = null
    return

  EventBus.emit_signal("player_acted")
  swap_tiles(selected_tile, tiles[grid_position.x][grid_position.y])
  swap_sound.play()

  selected_tile = null

func swap_tiles(selected, other):
  if selected == null || other == null:
    return

  var selected_position = selected.grid_position
  var other_position = other.grid_position

  tiles[other_position.x][other_position.y] = selected
  tiles[selected_position.x][selected_position.y] = other

  other.set_grid_position(selected_position)
  other.position = grid_to_pixel(selected_position)

  selected.set_grid_position(other_position)
  selected.position = grid_to_pixel(other_position)

  other.emit_signal("swapped", selected)
  selected.emit_signal("swapped", other)

  check_matches()

func check_matches():
  if evaluate_matches() > 0:
    execute_match()
  else:
    EventBus.emit_signal("turn_complete")

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

func mouse_to_grid():
  var mouse_position = get_viewport().get_mouse_position()
  return pixel_to_grid(mouse_position)

func get_enemies():
  var enemies = []
  for x in width:
    for y in height:
      if tiles[x][y] != null && is_instance_valid(tiles[x][y]) && tiles[x][y].get("enemy") && tiles[x][y].get("brain") != null:
        enemies.push_back(tiles[x][y])

  return enemies

func _input(event):
  if !Game.scene.player_control:
    return

  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT && event.pressed && !dragging:
      var grid_position = mouse_to_grid()
      if grid_position == null:
        swap_intent = null
        dragging = false
        if selected_tile != null:
          attempt_swap(selected_tile.grid_position)
        return

      selected_tile = tiles[grid_position.x][grid_position.y]
      selected_tile.start_drag()
      dragging = true
    elif event.button_index == BUTTON_LEFT and !event.pressed && dragging:
      attempt_swap(swap_intent)
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

func _on_level_completed():
  spawn_count = 0
  enemy_spawn_count = 0
  for y in range(height - 1, -1, -1):
    for x in width:
      if tiles[x][y] != null && tiles[x][y].player == false:
        tiles[x][y].hurt(100)
    sequence_timer.start(0.05)
    check_matches()
    yield(sequence_timer, "timeout")

  MusicPlayer.call_deferred("fade", "big_band", 1.0)
  teleport_rangers()
  yield(self, "sequence_completed")

  EventBus.emit_signal("spawn_shop")

  call_deferred("fade_out")
  yield(self, "sequence_completed")

func _on_start_level():
  if fade_tween.is_active():
    yield(self, "sequence_completed")

  MusicPlayer.call_deferred("fade", "ambient", 1.0)
  Game.scene.combo = 0
  populate_grid()

func _on_MatchTimer_timeout():
  if Game.scene.phase == Game.PHASE_PLAYER || Game.scene.phase == Game.PHASE_ENEMY:
    collapse_board()

func _on_CollapseTimer_timeout():
  check_matches()
