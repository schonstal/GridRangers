extends Area2D

var selected = false
var clicked = false
var active = false
var color = 'blue'

onready var tween = $Tween
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

  color = window.color

func set_ability(ability):
  if active_ability != null:
    active_ability.queue_free()

  active_ability = ability
  add_child(active_ability)
  active_ability.z_index = 10

func _process(delta):
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
    if active_ability != null:
      active_ability.scale = Vector2(1, 1)

func blur():
  if active_ability == null:
    return
  tween.stop_all()
  tween.interpolate_property(
      active_ability,
      "scale",
      active_ability.scale,
      Vector2(1, 1),
      0.1,
      Tween.TRANS_QUART,
      Tween.EASE_OUT
  )
  tween.start()

func hover():
  if active_ability == null:
    return
  tween.stop_all()
  tween.interpolate_property(
      active_ability,
      "scale",
      active_ability.scale,
      Vector2(1.2, 1.2),
      0.1,
      Tween.TRANS_QUART,
      Tween.EASE_OUT
  )
  tween.start()

func click():
  active_ability.scale = Vector2(0.8, 0.8)

func _on_energy_spent(amount):
  call_deferred("update_active")

func _on_energy_collected():
  call_deferred("update_active")

func _on_mouse_entered():
  if self.enough_energy:
    selected = true
    hover()

func _on_mouse_exited():
  selected = false
  clicked = false
  blur()

func _on_input_event(_viewport, event, _shape_id):
  if !selected || !active || !Game.scene.player_control:
    return

  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT:
      if event.pressed:
        clicked = true
        click()
      if !event.pressed && clicked:
        hover()
        clicked = false
        call_deferred("activate")

func _on_area_entered(other):
  print("entered", other)

func _on_area_exited(other):
  print("exited", other)
