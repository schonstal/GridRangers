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

func _ready():
  bg.frame = color_frames[color]
  head.frame = color_frames[color]
  frame.frame = color_frames[color]

  
  EventBus.connect("player_died", self, "_on_player_died")
  
func _on_player_died(player_color):
  if player_color == color:
    animation.play("Die")
