extends Sprite

onready var play_button = $PlayButton
onready var quit_button = $QuitButton
onready var tutorial_button = $TutorialButton
onready var appear_timer = $AppearTimer
onready var window_appear = $WindowAppear

func _ready():
  play_button.connect("pressed", self, "_on_PlayButton_pressed")
  quit_button.connect("pressed", self, "_on_QuitButton_pressed")
  appear_timer.connect("timeout", self, "_on_AppearTimer_timeout")
  EventBus.connect("victory", self, "_on_victory")

func _on_AppearTimer_timeout():
  window_appear.appear()

func _on_PlayButton_pressed():
  MusicPlayer.fade(null, 0.5)
  Game.return_to_title()

func _on_QuitButton_pressed():
  EventBus.emit_signal("quit_game")
  
func _on_victory():
  appear_timer.start()
