extends Node2D

var first_time = true

onready var message_timer = $MessageTimer
onready var done_button = $DoneButton
onready var window_appear = $WindowAppear
onready var abilities = $Abilities
onready var messages = $Messages
onready var equip_sound = $EquipSound
onready var reboot_sound = $RebootSound

var greetings = [
  "What R u buyin?",
  "U got the disks?",
  "I H8 those pigs."
]

var tutorial = [
  "U the one takin care of those pigs?",
  "If u got CDs, I can hook u up.",
  "Just drag a file to a RANGER window",
  "and I'll take the CDs from ur account."
]

func _ready():
  EventBus.connect("spawn_shop", self, "_on_spawn_shop")
  EventBus.connect("buy_ability", self, "_on_buy_ability")
  EventBus.connect("revive_ranger", self, "_on_revive_ranger")

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
  if Game.tutorial:
    return

  window_appear.call_deferred("appear")

  if first_time:
    for message in tutorial:
      EventBus.emit_signal("keeper_message", message)
    first_time = false
  else:
    greetings.shuffle()
    EventBus.emit_signal("keeper_message", greetings[0])

func _on_buy_ability(_ability):
  equip_sound.play()

func _on_revive_ranger(_color):
  reboot_sound.play()
