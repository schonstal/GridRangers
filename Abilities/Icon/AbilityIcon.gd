extends Node2D

onready var ability = $'..'

onready var icons = $Icons
onready var energy_label = $EnergyCost/Label

func _ready():
  energy_label.text = "%d" % ability.energy_cost
