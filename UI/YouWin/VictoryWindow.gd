extends Sprite

onready var restart_button = $RestartButton

func _ready():
  restart_button.connect("pressed", self, "_on_RestartButton_pressed")

func _on_RestartButton_pressed():
  Game.return_to_title()
