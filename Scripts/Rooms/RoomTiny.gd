extends "res://Scripts/Rooms/Room.gd"


func _on_DoorUpBuffer_body_entered(body):
	if body.is_in_group("Player"):
		body.moveVel = Vector3.ZERO
		body.global_transform.origin = self.global_transform.origin + Vector3(0,0.5,-2.75)
		player_entered(body)

func _on_DoorDownBuffer_body_entered(body):
	if body.is_in_group("Player"):
		body.moveVel = Vector3.ZERO
		body.global_transform.origin = self.global_transform.origin + Vector3(0,0.5,2.75)
		player_entered(body)

func _on_DoorLeftBuffer_body_entered(body):
	if body.is_in_group("Player"):
		body.moveVel = Vector3.ZERO
		body.global_transform.origin = self.global_transform.origin + Vector3(-2.75,0.5,0)
		player_entered(body)

func _on_DoorRightBuffer_body_entered(body):
	if body.is_in_group("Player"):
		body.moveVel = Vector3.ZERO
		body.global_transform.origin = self.global_transform.origin + Vector3(2.75,0.5,0)
		player_entered(body)


func player_entered(_body):
	pass
