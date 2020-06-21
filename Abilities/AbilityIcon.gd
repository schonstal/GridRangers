extends Node2D

onready var icons = $Icons
onready var cd_label = $CDCost/Label
onready var energy_label = $EnergyCost/Label

var active_ability = null

export var ability_name = "Plus"
export var energy_cost = 3
export var cd_cost = 50

func _ready():
  if ability_name == null:
    active_ability = null
  else:
    active_ability = icons.get_node(ability_name)

  if active_ability != null && is_instance_valid(active_ability):
    icons.visible = true
    for node in icons.get_children():
      node.visible = false
    active_ability.visible = true
  else:
    icons.visible = true

  cd_label.text = "%d" % cd_cost
  energy_label.text = "%d" % energy_cost
