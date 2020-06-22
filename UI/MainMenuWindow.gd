extends Sprite

onready var play_button = $PlayButton
onready var quit_button = $QuitButton

func _ready():
  play_button.connect("pressed", self, "_on_PlayButton_pressed")
  quit_button.connect("pressed", self, "_on_QuitButton_pressed")

func _on_PlayButton_pressed():
  EventBus.emit_signal("restart_game")
  
func _on_QuitButton_pressed():
  EventBus.emit_signal("quit_game")
