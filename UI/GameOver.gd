extends Node2D

onready var game_over_sound = $GameOverSound

func _ready():
  EventBus.connect("game_over", self, "_on_game_over")
  visible = false
  
func _on_game_over():
  visible = true
  game_over_sound.play()
