extends "res://Scripts/Rooms/RoomTiny.gd"

#var isDoorClosed = true

onready var keyAnimPlayer = $KeyArea/AnimationPlayer
onready var keyArea = $KeyArea


func _on_KeyArea_body_entered(body):
	if body.is_in_group("Player"):
		keyAnimPlayer.play("KeyAquired")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "KeyAquired":
		keyArea.queue_free()
