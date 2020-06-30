extends Node

func _ready():
  EventBus.connect("begin_phase", self, "_on_begin_phase")

func execute_turns():
  var enemies = Game.scene.grid.get_enemies()

  for enemy in enemies:
    if !is_instance_enemy(enemy):
      continue
    for i in enemy.brain.turn_count:
      if Game.scene.phase == Game.PHASE_NONE:
        return
      # enemy might die between turns if it matches itself
      if !is_instance_enemy(enemy):
        continue
      enemy.brain.call_deferred("execute_turn")
      yield(EventBus, "turn_complete")

  if Game.scene.kills < Game.scene.kill_target:
    EventBus.emit_signal("change_phase", Game.PHASE_PLAYER)

# is_instance_valid fails sometimes, it might be
# repopulated by now with a random object
func is_instance_enemy(enemy):
  return enemy != null &&\
         is_instance_valid(enemy) &&\
         enemy.get("enemy") &&\
         enemy.get("brain") != null &&\
         !enemy.get("dead")

func _on_begin_phase(phase):
  if phase == Game.PHASE_ENEMY:
    execute_turns()

func enemy_spawn_type(count):
  if Game.scene.current_level.standard_rate > 0 && count % Game.scene.current_level.standard_rate == 0:
    return "standard"
  elif Game.scene.current_level.moto_rate > 0 && count % Game.scene.current_level.moto_rate == 0:
    return "moto"
  elif Game.scene.current_level.shield_rate > 0 && count % Game.scene.current_level.shield_rate == 0:
    return "shield"

  return null
