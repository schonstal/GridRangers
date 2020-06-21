extends Node2D

onready var window_appear = $WindowAppear

func _ready():
  window_appear.appear(0.4)
