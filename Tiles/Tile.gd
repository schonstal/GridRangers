extends Area2D

export var type = "Default"
export var traversable = true
export var enemy = false
export var player = false
export var enemy_can_attack = false
export var health = 1
export var persistent = false

var grid_position = Vector2()
var previous_grid_position = Vector2()

var dragging = false
var drag_offset = Vector2()

var origin_position = Vector2()

var max_move = Vector2(128, 128)
var min_move = Vector2(128, 128)

var matched = false

var dead setget ,get_dead

signal matched
signal swapped(other)
signal moved
signal hurt

onready var move_tween = $MoveTween
onready var fade_tween = $FadeTween

func _ready():
  connect("input_event", self, "_on_Tile_input_event")
  move_tween.connect("tween_completed", self, "_on_MoveTween_tween_completed")
  fade_tween.connect("tween_completed", self, "_on_FadeTween_tween_completed")

func _process(delta):
  if dragging:
    drag()

func drag():
  var mouse_position = get_viewport().get_mouse_position()

  var new_position = Vector2(
      mouse_position.x,
      mouse_position.y
    ) + drag_offset

  var target = Vector2()
  if abs(origin_position.x - new_position.x) > abs(origin_position.y - new_position.y):
    target.x = max(min(new_position.x, origin_position.x + max_move.x), origin_position.x - min_move.x)
    target.y = origin_position.y
  else:
    target.x = origin_position.x
    target.y = max(min(new_position.y, origin_position.y + max_move.y), origin_position.y - min_move.y)

  global_position = lerp(global_position, target, 0.5)

func start_drag():
  dragging = true
  drag_offset = global_position - get_viewport().get_mouse_position()
  origin_position = global_position

func stop_drag():
  dragging = false

func hurt(damage):
  print(grid_position, "ouch", damage)
  health -= damage
  emit_signal("hurt")
  EventBus.emit_signal("explode", global_position)

func get_dead():
  return health < 1

func set_grid_position(new_position):
  previous_grid_position = grid_position
  grid_position = new_position

  if new_position.y == 0:
    min_move.y = 0
  else:
    min_move.y = 128

  if new_position.y == Game.scene.grid.height - 1:
    max_move.y = 0
  else:
    max_move.y = 128

  if new_position.x == 0:
    min_move.x = 0
  else:
    min_move.x = 128

  if new_position.x == Game.scene.grid.width - 1:
    max_move.x = 0
  else:
    max_move.x = 128

func match():
  emit_signal("matched")
  matched = true
  modulate = Color(10, 10, 10, 1)
  fade_tween.interpolate_property(
      self,
      "scale",
      scale,
      Vector2(1.0, 0),
      0.5,
      Tween.TRANS_ELASTIC,
      Tween.EASE_IN_OUT
    )
  fade_tween.start()

func move_to(new_position):
  move_tween.interpolate_property(
      self,
      "position",
      position,
      new_position,
      0.3,
      Tween.TRANS_QUART,
      Tween.EASE_OUT
    )
  move_tween.start()

func _on_MoveTween_tween_completed(_a, _b):
  emit_signal("moved")

func _on_FadeTween_tween_completed(_a, _b):
  if !persistent:
    queue_free()
