extends Area2D

var ability = preload("res://Abilities/Ability.tscn")

var dragging = false
var start_position = Vector2()
var drag_offset = Vector2()

onready var tween = $Tween
onready var cd_label = $CDCost/Label

func _ready():
  connect("mouse_entered", self, "_on_mouse_entered")
  connect("mouse_exited", self, "_on_mouse_exited")
  connect("input_event", self, "_on_input_event")

  start_position = global_position
  cd_label.text = "%d" % ability.cd_cost

func _process(delta):
  if dragging:
    drag()
  else:
    global_position = lerp(global_position, start_position, 0.3)

func drag():
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
  if z_index == 13:
    return

  z_index = 13

  for message in ability.description:
    EventBus.emit_signal("keeper_message", message)

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

func _on_input_event(_viewport, event, _shape_id):
  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT:
      if event.pressed:
        hover()
        drag_offset = global_position - get_viewport().get_mouse_position()
        dragging = true
      if !event.pressed:
        dragging = false
        for area in get_overlapping_areas():
          if area.has_method("set_ability"):
            if area.dead:
              EventBus.emit_signal("keeper_message", "I can't send it to an offline ranger.")
            elif Game.scene.coins >= ability.cd_cost:
              EventBus.emit_signal("keeper_message", "Thx. :)")
              area.call_deferred("set_ability", ability)
              ability.scale = Vector2(1, 1)
              remove_child(ability)
              EventBus.emit_signal("coins_spent", ability.cd_cost)
              queue_free()
            else:
              EventBus.emit_signal("keeper_message", "U need at least %d CDs for that." % ability.cd_cost)

