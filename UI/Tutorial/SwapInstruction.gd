extends Node2D

func _ready():
  EventBus.connect("player_acted", self, "_on_player_acted")
  
func _on_player_acted():
  visi


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
