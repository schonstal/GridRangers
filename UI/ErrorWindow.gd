extends Sprite

onready var restart_button = $RestartButton
onready var quit_button = $QuitButton
onready var timer = $Timer
onready var error_sound = $ErrorSound

func _ready():
  restart_button.connect("pressed", self, "_on_RestartButton_pressed")
  quit_button.connect("pressed", self, "_on_QuitButton_pressed")
  EventBus.connect("game_over", self, "_on_game_over")
  visible = false

func _on_RestartButton_pressed():
  EventBus.emit_signal("restart_game")
  
func _on_QuitButton_pressed():
  Game.return_to_title()
  
func _on_game_over():
  timer.start()
  yield(timer, "timeout")
  visible = true
  error_sound.play()  
