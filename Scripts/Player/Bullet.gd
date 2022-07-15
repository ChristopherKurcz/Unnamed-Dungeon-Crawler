extends "res://Scripts/Player/Projectile.gd"

var stats = PlayerStats

func enemy_hit():
	destroy()

func _on_Area_area_entered(area):
	if area.is_in_group("Enemy") and not stats.BULLETPIERCING:
		enemy_hit()
