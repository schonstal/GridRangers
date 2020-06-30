extends BackBufferCopy

onready var animation = $AnimationPlayer
onready var player_phase = $PlayerPhase
onready var enemy_phase = $EnemyPhase
onready var vhs = $VHS

func _ready():
  EventBus.connect("change_phase", self, "_on_change_phase")
  EventBus.connect("player_died", self, "_on_player_died")
  animation.connect("animation_finished", self, "_on_Animation_finished")

func _on_player_died(_color):
  animation.play("PlayerDied")

func _on_Animation_finished(name):
  if name == "ChangePhase":
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

