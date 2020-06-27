extends BackBufferCopy

onready var animation = $AnimationPlayer
onready var player_phase = $PlayerPhase
onready var enemy_phase = $EnemyPhase

func _ready():
  EventBus.connect("change_phase", self, "_on_change_phase")
  animation.connect("animation_finished", self, "_on_Animation_finished")

func _on_Animation_finished(name):
  EventBus.emit_signal("phase_transition_complete")

func _on_change_phase(phase):
  if phase == Game.PHASE_NONE:
    return

  animation.play("ChangePhase")

  MusicPlayer.call_deferred("fade_filter", 1.6)

  if phase == Game.PHASE_PLAYER:
    player_phase.visible = true
    enemy_phase.visible = false
  else:
    player_phase.visible = false
    enemy_phase.visible = true
