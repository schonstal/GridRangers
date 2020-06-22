extends Node

export var energy_cost = 6

func activate_at(position):
  EventBus.emit_signal("cola_collected")
  EventBus.emit_signal("cola_collected")
  EventBus.emit_signal("cola_collected")
  EventBus.emit_signal("cola_collected")
  EventBus.emit_signal("turn_complete")
