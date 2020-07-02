extends Node

# Effects
signal blur_chromatic(size, duration)
signal explode(position)

# Phase Transitions
signal phase_transition_complete
signal change_phase(phase)
signal begin_phase(phase)

# Spawning/Death
signal enemy_spawned(enemy)
signal enemy_died(enemy)
signal player_died(color)
signal revive_ranger(color)

# Shop
signal spawn_shop
signal keeper_message(message)
signal buy_ability(ability)

# Resources
signal coin_collected
signal coins_spent(amount)
signal cola_collected
signal energy_collected
signal energy_spent

# Turns
signal turns_spent(amount)
signal player_acted
signal turn_complete
signal action_complete

# Game State
signal level_completed
signal start_level
signal restart_game
signal quit_game
signal game_over
signal victory

# Sound
signal play_sound(category, sound)

# Tutorial
signal highlight_tile(position)
signal begin_tutorial_state(state)
signal end_tutorial_state(state)
signal tutorial_complete
