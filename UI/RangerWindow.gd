extends Node2D

export var color = 'blue'

onready var bg = $Bg
onready var head = $Head
onready var frame = $Frame

onready var animation = $AnimationPlayer

var color_frames = {
  'blue': 0,
  'red': 1,
  'yellow': 2
}

var appear_delay = {
  'red': 0,
  'blue': 0.1,
  'yellow': 0.2
}

func _ready():
  bg.frame = color_frames[color]
  head.frame = color_frames[color]
  frame.frame = color_frames[color]

  appear()

  EventBus.connect("player_died", self, "_on_player_died")

func appear():
  var appear_tween = Tween.new()
  add_child(appear_tween)

  var duration = 0.3
  var start_position = global_position
  global_position = Vector2(global_position.x, 1280)

  appear_tween.interpolate_property(
      self,
      "global_position",
      global_position,
      start_position,
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT,
      appear_delay[color]
    )
  appear_tween.interpolate_property(
      self,
      "scale",
      Vector2(0, 0),
      Vector2(1, 1),
      duration,
      Tween.TRANS_QUART,
      Tween.EASE_OUT,
      appear_delay[color]
    )

  appear_tween.start()
  yield(appear_tween, "tween_completed")
  appear_tween.queue_free()

func _on_player_died(player_color):
  if player_color == color:
    animation.play("Die")
