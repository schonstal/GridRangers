extends Area2D

export var type = "Default"

var grid_position = Vector2()

var dragging = false
var drag_offset = Vector2()

var origin_position = Vector2()

func _ready():
  connect("input_event", self, "_on_Tile_input_event")

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
    global_position.x = max(min(new_position.x, origin_position.x + 128), origin_position.x - 128)
    global_position.y = origin_position.y
  else:
    global_position.x = origin_position.x
    global_position.y = max(min(new_position.y, origin_position.y + 128), origin_position.y - 128)

func start_drag():
  dragging = true
  drag_offset = global_position - get_viewport().get_mouse_position()
  origin_position = global_position

func stop_drag():
  dragging = false
