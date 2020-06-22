extends Node2D

func _ready():
  EventBus.connect("game_over", self, "_on_game_over")
  
func _on_game_over():
  visible = true
