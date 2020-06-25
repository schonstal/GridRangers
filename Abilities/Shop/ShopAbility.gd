extends Area2D

var ability = preload("res://Abilities/Ability.tscn")

var dragging = false
var start_position = Vector2()
var drag_offset = Vector2()

onready var tween = $Tween
onready var cd_label = $CDCost/Label
onready var click_sound = $ClickSound
onready var error_sound = $ErrorSound

func _ready():
  connect("mouse_entered", self, "_on_mouse_entered")
  connect("mouse_exited", self, "_on_mouse_exited")
  connect("input_event", self, "_on_input_event")
  EventBus.connect("coins_spent", self, "_on_coins_spent")

  start_position = global_position
  cd_label.text = "%d" % ability.cd_cost

  ability.scale = Vector2(0, 0)

  if !can_afford():
    modulate = Color(0.5, 0.5, 0.5, 1)

  tween.interpolate_property(
      ability,
      "scale",
      Vector2(0, 0),
      Vector2(1, 1),
      0.3,
      Tween.TRANS_QUART,
      Tween.EASE_OUT
  )
  tween.start()

func _on_coins_spent(_coins):
  if !can_afford():
    modulate = Color(0.5, 0.5, 0.5, 1)
    deselect()

func can_afford():
  return ability.cd_cost <= Game.scene.coins

func _process(delta):
  if dragging:
    drag()
  else:
    global_position = lerp(global_position, start_position, 0.3)

func drag():
  if !can_afford():
    return

  var mouse_position = get_viewport().get_mouse_position()

  global_position = Vector2(
      mouse_position.x,
      mouse_position.y
    ) + drag_offset

func _on_mouse_entered():
  if Input.is_mouse_button_pressed(BUTTON_LEFT):
    return

  hover()

func hover():
  if z_index == 13 || !can_afford():
    return

  z_index = 13

  tween.stop_all()
  tween.interpolate_property(
      ability,
      "scale",
      ability.scale,
      Vector2(1.2, 1.2),
      0.1,
      Tween.TRANS_QUART,
      Tween.EASE_OUT
  )
  tween.start()

func _on_mouse_exited():
  if dragging:
    return
  deselect()

func deselect():
  z_index = 12

  tween.stop_all()
  tween.interpolate_property(
      ability,
      "scale",
      ability.scale,
      Vector2(1, 1),
      0.1,
      Tween.TRANS_QUART,
      Tween.EASE_OUT
  )
  tween.start()

func drop_ability(area):
  if area.dead:
    error_sound.play()
    EventBus.emit_signal("keeper_message", "I can't send it to an offline ranger.")
  elif can_afford():
    EventBus.emit_signal("buy_ability", ability)
    EventBus.emit_signal("keeper_message", "Thx. :)")
    area.call_deferred("set_ability", ability)
    ability.scale = Vector2(1, 1)
    remove_child(ability)
    EventBus.emit_signal("coins_spent", ability.cd_cost)
    queue_free()

func drop_revive(area):
  if area.dead:
    if can_afford():
      EventBus.emit_signal("revive_ranger", area.color)
      EventBus.emit_signal("keeper_message", "Sending reboot sequence...")
      EventBus.emit_signal("coins_spent", ability.cd_cost)
      queue_free()
  else:
    error_sound.play()
    EventBus.emit_signal("keeper_message", "That ranger is online...")
    EventBus.emit_signal("keeper_message", "I can't reboot the terminal.")

func _on_input_event(_viewport, event, _shape_id):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT:
      if event.pressed:
        if can_afford():
          hover()
          drag_offset = global_position - get_viewport().get_mouse_position()
          dragging = true
          click_sound.play()
        else:
          error_sound.play()
          EventBus.emit_signal("keeper_message", "U need at least %d CDs for that." % ability.cd_cost)
      if !event.pressed:
        dragging = false
        for area in get_overlapping_areas():
          if area.has_method("set_ability"):
            if ability == null:
              return

            if ability.revive:
              drop_revive(area)
            else:
              drop_ability(area)
