extends Sprite

onready var play_button = $PlayButton
onready var quit_button = $QuitButton
onready var tutorial_button = $TutorialButton
onready var appear_timer = $AppearTimer
onready var window_appear = $WindowAppear

func _ready():
  play_button.connect("pressed", self, "_on_PlayButton_pressed")
  tutorial_button.connect("pressed", self, "_on_TutorialButton_pressed")
  quit_button.connect("pressed", self, "_on_QuitButton_pressed")
  appear_timer.connect("timeout", self, "_on_AppearTimer_timeout")
  
func _on_AppearTimer_timeout():
  window_appear.appear()

func _on_PlayButton_pressed():
  Game.tutorial = false
  MusicPlayer.fade("none", 0.5)
  EventBus.emit_signal("restart_game")

func _on_TutorialButton_pressed():
  Game.tutorial = true
  MusicPlayer.fade("none", 0.5)
  EventBus.emit_signal("restart_game")
  
func _on_QuitButton_pressed():
  EventBus.emit_signal("quit_game")
