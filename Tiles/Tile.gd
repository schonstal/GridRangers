extends Area2D

export var type = "Default"

var grid_position = Vector2()

var dragging = false
var drag_offset = Vector2()

var origin_position = Vector2()

var max_move = Vector2(128, 128)
var min_move = Vector2(128, 128)

var matched = false

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

  if abs(origin_position.x - new_position.x) > abs(origin_position.y - new_position.y):
    global_position.x = max(min(new_position.x, origin_position.x + max_move.x), origin_position.x - min_move.x)
    global_position.y = origin_position.y
  else:
    global_position.x = origin_position.x
    global_position.y = max(min(new_position.y, origin_position.y + max_move.y), origin_position.y - min_move.y)

func start_drag():
  dragging = true
  drag_offset = global_position - get_viewport().get_mouse_position()
  origin_position = global_position

func stop_drag():
  dragging = false

func set_grid_position(new_position):
  grid_position = new_position

  if new_position.y == 0:
    min_move.y = 0
  else:
    min_move.y = 128

  if new_position.y == 7:
    max_move.y = 0
  else:
    max_move.y = 128

  if new_position.x == 0:
    min_move.x = 0
  else:
    min_move.x = 128

  if new_position.x == 7:
    max_move.x = 0
  else:
    max_move.x = 128

func match():
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
  pass

func _on_FadeTween_tween_completed(_a, _b):
  queue_free()
