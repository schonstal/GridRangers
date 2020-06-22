extends Area2D

var selected = false
var clicked = false
var active = false
var color = 'blue'

onready var animation = $AnimationPlayer

onready var window = $'..'

var active_ability = null

var dead setget ,_get_dead
var enough_energy setget ,_get_enough_energy

func _ready():
  connect("mouse_entered", self, "_on_mouse_entered")
  connect("mouse_exited", self, "_on_mouse_exited")
  connect("input_event", self, "_on_input_event")

  connect("on_area_entered", self, "_on_area_entered")
  connect("on_area_exited", self, "_on_area_exited")

  EventBus.connect("energy_collected", self, "_on_energy_collected")
  EventBus.connect("energy_spent", self, "_on_energy_spent")

func set_ability(ability):
  active_ability = ability
  add_child(active_ability)

func _process(delta):
  if !selected && active_ability:
    active_ability.scale.x = lerp(active_ability.scale.x, 1, 0.5)
    active_ability.scale.y = lerp(active_ability.scale.y, 1, 0.5)

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
      EventBus.emit_signal("player_acted")
      # Game jam haxxx
      Game.scene.players[color].get_node("Brain").call_deferred("attack")

  update_active()

func _get_dead():
  return window.dead

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

func _on_energy_spent(amount):
  call_deferred("update_active")

func _on_energy_collected():
  call_deferred("update_active")

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

func _on_area_entered(other):
  print("entered", other)

func _on_area_exited(other):
  print("exited", other)
