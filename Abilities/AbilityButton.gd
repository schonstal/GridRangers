extends Area2D

var selected = false
var clicked = false
var active = false
var color = 'blue'

onready var animation = $AnimationPlayer
onready var abilities = $Abilities
onready var window = $'..'

var active_ability = null

var enough_energy setget ,_get_enough_energy

func _ready():
  connect("mouse_entered", self, "_on_mouse_entered")
  connect("mouse_exited", self, "_on_mouse_exited")
  connect("input_event", self, "_on_input_event")

  EventBus.connect("energy_collected", self, "_on_energy_collected")

  color = window.color

  if color == 'red':
    set_ability('ClearRow')
  elif color == 'blue':
    set_ability('ClearColumn')
  else:
    set_ability(null)

func _process(delta):
  if !selected:
    abilities.scale.x = lerp(abilities.scale.x, 1, 0.5)
    abilities.scale.y = lerp(abilities.scale.y, 1, 0.5)

func set_ability(ability_name):
  if ability_name == null:
    active_ability = null
  else:
    active_ability = abilities.get_node(ability_name)
    print(active_ability)

  if active_ability != null && is_instance_valid(active_ability):
    abilities.visible = true
    for node in abilities.get_children():
      node.visible = false
    active_ability.visible = true
  else:
    abilities.visible = true

  update_active()

func activate():
  if active_ability == null ||\
     !is_instance_valid(active_ability) ||\
     !Game.scene.player_control:
    return

  if self.enough_energy:
    if active_ability.has_method("activate_at"):
      Game.scene.disable_input()
      EventBus.emit_signal("energy_spent", active_ability.energy_cost)
      active_ability.activate_at(Game.scene.players[color].grid_position)

  update_active()

func _get_enough_energy():
  return active_ability != null &&\
         is_instance_valid(active_ability) &&\
         active_ability.get("energy_cost") != null &&\
         active_ability.energy_cost <= Game.scene.energy

func update_active():
  if self.enough_energy:
    active = true
    modulate = Color(1, 1, 1, 1)
  else:
    active = false
    modulate = Color(0.5, 0.5, 0.5, 1)

func _on_energy_collected():
  update_active()

func _on_mouse_entered():
  if self.enough_energy:
    selected = true
    animation.play("Hover")

func _on_mouse_exited():
  selected = false
  clicked = false
  animation.stop()

func _on_input_event(_viewport, event, _shape_id):
  if !selected || !active || !Game.scene.player_control:
    return

  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT:
      if event.pressed:
        clicked = true
        animation.play("Click")
      if !event.pressed && clicked:
        animation.play("Hover")
        clicked = false
        call_deferred("activate")
