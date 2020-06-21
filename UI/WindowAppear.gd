extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var window = $'..'
var initial_position

# Called when the node enters the scene tree for the first time.
func _ready():
  initial_position = window.global_position

func appear(delay = 0):
  window.visible = true
  var appear_tween = Tween.new()
  add_child(appear_tween)

  var duration = 0.3
  var start_position = initial_position
  window.global_position = Vector2(window.global_position.x, 1280)

  appear_tween.interpolate_property(
      window,
      "global_position",
      window.global_position,
      start_position,
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT,
      delay
    )
  appear_tween.interpolate_property(
      window,
      "scale",
      Vector2(0, 0),
      Vector2(1, 1),
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT,
      delay
    )

  appear_tween.start()
  yield(appear_tween, "tween_completed")
  appear_tween.queue_free()

func disappear(delay = 0):
  var disappear_tween = Tween.new()
  add_child(disappear_tween)

  var duration = 0.3
  var start_position = initial_position

  disappear_tween.interpolate_property(
      window,
      "global_position",
      window.global_position,
      Vector2(window.global_position.x, 1280),
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT,
      delay
    )
  disappear_tween.interpolate_property(
      window,
      "scale",
      Vector2(1, 1),
      Vector2(1, 1),
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT,
      delay
    )

  disappear_tween.start()
  yield(disappear_tween, "tween_completed")
  window.visible = false
  disappear_tween.queue_free()
