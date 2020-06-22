extends Sprite

onready var restart_button = $RestartButton
onready var quit_button = $QuitButton

func _ready():
  restart_button.connect("pressed", self, "_on_RestartButton_pressed")
  quit_button.connect("pressed", self, "_on_QuitButton_pressed")

func _on_RestartButton_pressed():
  EventBus.emit_signal("restart_game")
  
func _on_QuitButton_pressed():
  EventBus.emit_signal("quit_game")
