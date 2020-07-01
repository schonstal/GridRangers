extends Node2D

onready var states = [$Swap, $Moves, $Pig]
onready var backdrop = $Backdrop

var state = 0

onready var back

func _ready():
  if !Game.tutorial:
    queue_free()
    return

  EventBus.connect("player_acted", self, "_on_player_acted")
  EventBus.connect("turn_complete", self, "_on_turn_complete")
  EventBus.connect("phase_transition_complete", self, "_on_phase_transition_complete")

func show_state():
  if state >= states.size():
    return

  backdrop.visible = true
  states[state].visible = true

  if state == 0:
    EventBus.emit_signal("highlight_tile", Vector2(5, 1))
    EventBus.emit_signal("highlight_tile", Vector2(6, 1))
  elif state == 1:
    EventBus.emit_signal("highlight_tile", Vector2(4, 0))
    EventBus.emit_signal("highlight_tile", Vector2(4, 1))
  elif state == 2:
    EventBus.emit_signal("highlight_tile", Vector2(5, 5))
    EventBus.emit_signal("highlight_tile", Vector2(5, 6))

func _on_phase_transition_complete():
  show_state()

func _on_turn_complete():
  show_state()

func _on_player_acted():
  if state < states.size():
    states[state].visible = false
    backdrop.visible = false
    state += 1
