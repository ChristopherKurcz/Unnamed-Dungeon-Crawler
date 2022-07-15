extends "res://Scripts/Player/Projectile.gd"

var KNOCKSTRENGTH = 15

func player_hit():
	.destroy()


func _on_Area_area_entered(area):
	if area.is_in_group("Player"):
		player_hit()
