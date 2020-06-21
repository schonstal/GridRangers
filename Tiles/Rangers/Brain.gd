extends Node

onready var tile = $'..'
onready var animation = $'../Sprite/AnimationPlayer'
onready var sprite = $'../Sprite'
onready var teleport_animation = $'../Teleport/AnimationPlayer'

export var color = 'red'
export var attack_offset = Vector2()
export var idle_offset = Vector2()

signal teleport_completed

func _ready():
  tile.connect("swapped", self, "_on_swapped")
  tile.connect("matched", self, "_on_matched")
  sprite.position = idle_offset

func _on_matched():
  EventBus.emit_signal("player_died", color)

func _on_swapped(other_tile):
  if Game.scene.phase == Game.PHASE_PLAYER:
    if other_tile.enemy:
      other_tile.hurt(1)
      call_deferred("attack")

func teleport():
  if sprite.visible:
    teleport_animation.play("TeleportOut")
  else:
    teleport_animation.play("TeleportIn")

  yield(teleport_animation, "animation_finished")
  emit_signal("teleport_completed")

func attack():
  animation.play("Attack")
  yield(animation, "animation_finished")
  animation.play("Idle")

func go_to_idle():
  sprite.position = idle_offset

func go_to_attack():
  sprite.position = attack_offset
