extends Node2D

var first_time = true

onready var message_timer = $MessageTimer
onready var done_button = $DoneButton
onready var window_appear = $WindowAppear
onready var abilities = $Abilities
onready var messages = $Messages

var greetings = [
  "What R u buyin?",
  "U got the disks?",
  "I H8 those pigs."
]

var tutorial = [
  "U the one takin care of those pigs?",
  "If U got CDs, I can hook U up.",
  "Drag a file to a RANGER window to buy it."
]

func _ready():
  EventBus.connect("spawn_shop", self, "_on_spawn_shop")
  done_button.connect("pressed", self, "_on_DoneButton_pressed")
  window_appear.connect("appeared", self, "_on_window_appeared")

func _on_window_appeared():
  abilities.visible = true
  abilities.spawn_abilities()

func _on_DoneButton_pressed():
  window_appear.disappear()
  abilities.visible = false
  EventBus.emit_signal("keeper_message", "L8r.")
  EventBus.emit_signal("keeper_message", "============= DISCONNECTED =============")
  EventBus.emit_signal("start_level")

func _on_spawn_shop():
  window_appear.call_deferred("appear")

  EventBus.emit_signal("keeper_message", "Hey.")
  if first_time:
    for message in tutorial:
      EventBus.emit_signal("keeper_message", message)
    first_time = false
  else:
    greetings.shuffle()
    EventBus.emit_signal("keeper_message", greetings[0])
