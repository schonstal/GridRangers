extends Node2D

onready var pips = $Pips
onready var pause = $Pause
onready var play = $Play

func _ready():
  EventBus.connect("change_phase", self, "_on_change_phase")
  EventBus.connect("phase_transition_complete", self, "_on_phase_transition_complete")
  update_label()

func _process(delta):
  update_pips()

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

