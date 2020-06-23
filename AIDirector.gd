extends Node

func _ready():
  EventBus.connect("begin_phase", self, "_on_begin_phase")

func execute_turns():
  var enemies = Game.scene.grid.get_enemies()

  for enemy in enemies:
    if !is_instance_enemy(enemy):
      continue
    for i in enemy.brain.turns:
      # enemy might die between turns if it matches itself
      if !is_instance_enemy(enemy):
        continue
      enemy.brain.call_deferred("execute_turn")
      yield(EventBus, "turn_complete")

  EventBus.emit_signal("change_phase", Game.PHASE_PLAYER)

# is_instance_valid fails sometimes, it might be
# repopulated by now with a random object
func is_instance_enemy(enemy):
  return enemy != null && is_instance_valid(enemy) && enemy.get("brain") != null && !enemy.get("dead")

func _on_begin_phase(phase):
  if phase == Game.PHASE_ENEMY:
    execute_turns()
