extends Node

onready var animation = $'../Sprite/AnimationPlayer'
onready var tile = $'../'

var sleeping = true

func _ready():
  animation.connect("animation_finished", self, "_on_Animation_finished")
  tile.connect("matched", self, "_on_matched")
  tile.connect("swapped", self, "_on_swapped")

  EventBus.emit_signal("enemy_spawned", self)

func execute_turn():
  if sleeping:
    sleeping = false
    animation.play("WakeUp")
  else:
    Game.scene.pathfinder.generate_map()
    var paths = []

    var points_relative = PoolVector2Array([
      Vector2(tile.grid_position.x + 1, tile.grid_position.y),
      Vector2(tile.grid_position.x - 1, tile.grid_position.y),
      Vector2(tile.grid_position.x, tile.grid_position.y + 1),
      Vector2(tile.grid_position.x, tile.grid_position.y - 1)])

    for player in Game.scene.players:
      if !is_instance_valid(player):
        continue

      for start in points_relative:
        var tile = Game.scene.grid.get_tile(start)
        if tile == null || tile.enemy:
          continue
        var end = player.grid_position
        var path = Game.scene.pathfinder.find_path(start, end)
        if path != null:
          paths.append(path)

    var shortest_path = null
    var length = 100
    for path in paths:
      var size = path.size()
      if size > 0 && size < length:
        shortest_path = path
        length = size

    if shortest_path == null || shortest_path.size() < 1:
      EventBus.emit_signal("turn_complete")
    else:
      var to_swap = shortest_path[0]
      Game.scene.grid.auto_swap(tile.grid_position, to_swap)

func _on_swapped():
  if Game.scene.phase == Game.PHASE_ENEMY:
    var other_tile = Game.scene.grid.get_tile(tile.previous_grid_position)
    if other_tile.player:
      other_tile.hurt(1)

func _on_matched():
  animation.play("Die")
  EventBus.emit_signal("enemy_died", self)

func _on_Animation_finished(name):
  if name == "WakeUp":
    EventBus.emit_signal("turn_complete")
    animation.play("Idle")
