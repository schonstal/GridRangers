extends Node

signal blur_chromatic(size, duration)
signal turn_complete
signal action_complete

signal phase_transition_complete
signal change_phase(phase)
signal begin_phase(phase)

signal enemy_spawned(enemy)
signal enemy_died(enemy)

signal player_died(color)
signal revive_ranger(color)
signal buy_ability(ability)

signal coin_collected
signal coins_spent(amount)
signal cola_collected

signal energy_collected
signal energy_spent

signal explode(position)

signal player_acted

signal keeper_message(message)

signal level_completed
signal start_level

signal spawn_shop

signal restart_game
signal quit_game
signal game_over

signal play_sound(category, sound)

signal turns_spent(amount)
