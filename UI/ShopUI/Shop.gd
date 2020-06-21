extends Node2D

var greetings = [
  "What R u buyin?",
  "U got the disks?",
  "I H8 those pigs."
]

func _ready():
  greetings.shuffle()
  EventBus.emit_signal("keeper_message", greetings[0])

func _process(delta):
  if Input.is_action_just_pressed("ui_accept"):
    greetings.shuffle()
    EventBus.emit_signal("keeper_message", greetings[0])
