extends Node2D

onready var victory_sound = $VictorySound

func _ready():
  EventBus.connect("victory", self, "_on_victory")
  visible = false
  
func _on_victory():
  return
  visible = true
  victory_sound.play()
  MusicPlayer.call_deferred("fade", "end", 0.1)
