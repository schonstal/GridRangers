extends Node

var enemies = []

func _ready():
  EventBus.connect("enemy_spawned", self, "_on_enemy_spawned")
  EventBus.connect("enemy_died", self, "_on_enemy_died")
  EventBus.connect("begin_phase", self, "_on_begin_phase")

func execute_turns():
  for enemy in enemies:
    enemy.execute_turn()
    yield(EventBus, "turn_complete")

  EventBus.emit_signal("change_phase", Game.PHASE_PLAYER)

func _on_begin_phase(phase):
  if phase == Game.PHASE_ENEMY:
    execute_turns()

func _on_enemy_spawned(enemy):
  enemies.push_back(enemy)

func _on_enemy_died(enemy):
  enemies.remove(enemies.find(enemy))

