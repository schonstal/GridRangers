extends Node2D

export var cd_cost = 20
export var energy_cost = 5
export var description = [
  "Attack all tiles in the ranger's column."
 ]

onready var icon = $Icon
onready var effect = $Effect

func activate_at(position):
  if effect != null && effect.has_method("activate_at"):
    effect.activate_at(position)
