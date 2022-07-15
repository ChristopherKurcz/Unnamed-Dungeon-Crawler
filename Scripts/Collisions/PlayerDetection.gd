extends Area

var player = null


func _ready():
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			player = body


func can_see_player():
	return player != null


func _on_PlayerDetection_body_exited(_body):
	player = null


func _on_PlayerDetection_body_entered(body):
	player = body
