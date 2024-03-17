extends Node

signal stat_change
signal weapon_changed(weapon_name: String)
var player_max_health: int = 200
var player_vulnerable: bool = true

var player_position: Vector2 = Vector2.ZERO

var player_health: int = 200:
	set(value):
		if value < player_health:
			if player_vulnerable:
				print("player health now at ")
				print(player_health)
				player_health = value
				player_vulnerable = false
				player_invulnerable_timer()
				# TODO add some visual/audio indicator
		else:
			player_health = min(value, player_max_health)
		stat_change.emit()

var equipped_weapon: String = "pistol":
	set(value):
		# Ignore inputs to switch to the same weapon
		if (equipped_weapon != value):
			equipped_weapon = value
			weapon_changed.emit(value)
		
func player_invulnerable_timer():
	await get_tree().create_timer(.5).timeout
	player_vulnerable = true
