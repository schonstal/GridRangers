extends Node

onready var animation = $'../Sprite/AnimationPlayer'
onready var tile = $'../'
onready var sprite = $'../Sprite'

var sleeping
var awake_chance = 50

export var turns = 1
var turn_count = 1

func _ready():
  animation.connect("animation_finished", self, "_on_Animation_finished")
  tile.connect("matched", self, "_on_matched")
  tile.connect("swapped", self, "_on_swapped")

  var points_relative = [
      Vector2(tile.grid_position.x, tile.grid_position.y + 1),
      Vector2(tile.grid_position.x, tile.grid_position.y - 1),
      Vector2(tile.grid_position.x - 1, tile.grid_position.y),
      Vector2(tile.grid_position.x + 1, tile.grid_position.y)
    ]

  for point in points_relative:
    var neighbor = Game.scene.grid.get_tile(point)
    if neighbor != null && neighbor.player:
      sleeping = true

  if sleeping == null:
    sleeping = rand_range(0, 100) > awake_chance

  EventBus.emit_signal("enemy_spawned", self)

  if !sleeping:
    animation.play("WakeUp")

func execute_turn():
  if sleeping:
    sleeping = false
    animation.play("WakeUp")
    yield(animation, "animation_finished")
    EventBus.emit_signal("turn_complete")
  else:
    Game.scene.pathfinder.generate_map(tile.grid_position)

    var paths = []

    var length = 100
    var shortest_path = null
    for key in Game.scene.players:
      var player = Game.scene.players[key]
      if !is_instance_valid(player) || player.dead:
        continue

      var path = Game.scene.pathfinder.find_path(tile.grid_position, player.grid_position)
      if path != null:
        var size = path.size()
        if size > 0 && size < length:
          shortest_path = path
          length = size

    if shortest_path == null || shortest_path.size() < 1:
      EventBus.emit_signal("turn_complete")
    else:
      var to_swap = shortest_path[1]
      var target = Game.scene.grid.get_tile(to_swap)
      if target.traversable:
        Game.scene.grid.auto_swap(tile.grid_position, to_swap)
      else:
        target.hurt(1)
        animation.play("Attack")
        yield(animation, "animation_finished")
        EventBus.emit_signal("turn_complete")

func _on_swapped(other_tile):
  if Game.scene.phase == Game.PHASE_ENEMY:
    if other_tile.enemy_can_attack:
      other_tile.hurt(1)
      animation.play("Attack")

func _on_matched():
  animation.play("Die")
  EventBus.emit_signal("enemy_died", self)

func _on_Animation_finished(name):
  if name == "WakeUp":
    turn_count = turns
    animation.play("Idle")

  if name == "Attack":
    animation.play("Idle")
