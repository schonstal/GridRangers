extends Node2D

onready var pips = $Pips
onready var pause = $Pause
onready var play = $Play
onready var flash_tween = $FlashTween

func _ready():
  EventBus.connect("change_phase", self, "_on_change_phase")
  EventBus.connect("phase_transition_complete", self, "_on_phase_transition_complete")
  EventBus.connect("turns_spent", self, "_on_turns_spent")
  update_label()

func _process(delta):
  update_pips()

func _on_turns_spent(turns):
  flash_tween.stop_all()
  flash_tween.interpolate_property(
    pips,
    "modulate",
    Color(10, 10, 10, 1),
    Color(1, 1, 1, 1),
    1.0,
    Tween.TRANS_QUART,
    Tween.EASE_OUT
  )
  flash_tween.start()

func update_pips():
  var i = 0
  for pip in pips.get_children():
    if Game.scene.player_moves > i:
      pip.enable()
    else:
      pip.disable()
    i += 1

func _on_change_phase(phase):
  visible = false

func _on_phase_transition_complete():
  visible = true
  update_label()

func update_label():
  if Game.scene.phase == Game.PHASE_PLAYER:
    pause.visible = true
    play.visible = false
    pips.visible = true
  elif Game.scene.phase == Game.PHASE_ENEMY:
    pips.visible = false
    pause.visible = false
    play.visible = true
  else:
    visible = false

