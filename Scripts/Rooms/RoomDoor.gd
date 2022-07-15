extends "res://Scripts/Rooms/RoomTiny.gd"

#var isDoorClosed = true

onready var doorClosed = $DoorClosed
onready var doorOpen = $DoorOpen


func open_door():
	doorClosed.visible = false
	doorOpen.visible = true


func player_entered(body):
	if body.stats.hasKey:
		open_door()


func _on_TrapDoorArea_body_entered(body):
	if body.is_in_group("Player"):
		if body.stats.hasKey:
			get_tree().call_group("GameMaster", "door_entered")
