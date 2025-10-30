extends Node

# Player signals
signal player_damaged(damage_amount)
signal player_died
signal powerup_collected(powerup_type)

# Enemy signals
signal enemy_spawned(enemy)
signal enemy_died(enemy_type, position, points)
signal enemy_hit(enemy, damage)

# Game state signals
signal score_changed(new_score)
signal level_changed(new_level)
signal game_over(final_score)
signal level_complete

# World signals
signal file_hit(file)
signal firewall_activated

# UI signals
signal update_ui_score(score)
signal update_ui_lives(lives)
signal show_message(message, duration)
