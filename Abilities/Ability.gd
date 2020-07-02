extends Node2D

export var cd_cost = 20
export var energy_cost = 5
export var description = ""

export var revive = false

onready var effect = $Effect

func activate_at(position):
  if effect != null && effect.has_method("activate_at"):
    effect.activate_at(position)
