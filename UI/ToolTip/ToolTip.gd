extends Label

onready var tile = $'../..'
onready var container = $'..'

export var idle_time = 1.0
var show_time = 0.0

var hovering = false
var last_position = Vector2(0, 0)

func _ready():
  tile.connect("input_event", self, "_on_Tile_input_event")
  container.visible = false
  
func _process(delta):
  if !hovering:
    return

  var mouse_position = get_viewport().get_mouse_position()
  if (mouse_position - last_position).length() > 3.0:
    hovering = false
    container.visible = false
    show_time = 0
    return

  show_time += delta
  if show_time >= idle_time:
    container.visible = true

func _on_Tile_input_event(_vp, event, _idx):
  if !Game.scene.player_control:
    return

  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT && event.pressed && !hovering:
      hovering = true
      last_position = get_viewport().get_mouse_position()
    elif event.button_index == BUTTON_LEFT and !event.pressed && hovering:
      hovering = false
      show_time = 0
      container.visible = false
