extends Node2D

export var color = 'blue'

onready var bg = $Bg
onready var head = $Head
onready var frame = $Frame
onready var error = $Error

onready var animation = $AnimationPlayer
onready var window_appear = $WindowAppear

var dead = false

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

  window_appear.appear(appear_delay[color])

  EventBus.connect("player_died", self, "_on_player_died")
  EventBus.connect("revive_ranger", self, "_on_revive_ranger")

func _on_revive_ranger(player_color):
  if player_color == color:
    bg.frame = color_frames[color]
    head.frame = color_frames[color]
    frame.frame = color_frames[color]
    animation.play("Revive")
    dead = false

func _on_player_died(player_color):
  if player_color == color:
    animation.play("Die")
    dead = true
