extends "res://Scripts/Rooms/Room.gd"


func close_gates():
	if "up" in adjRooms:
		var upGate = self.get_node("Gates/GateUp")
		upGate.visible = true
		upGate.get_node("CollisionShape").disabled = false
	if "down" in adjRooms:
		var downGate = self.get_node("Gates/GateDown")
		downGate.visible = true
		downGate.get_node("CollisionShape").disabled = false
	if "left" in adjRooms:
		var leftGate = self.get_node("Gates/GateLeft")
		leftGate.visible = true
		leftGate.get_node("CollisionShape").disabled = false
	if "right" in adjRooms:
		var rightGate = self.get_node("Gates/GateRight")
		rightGate.visible = true
		rightGate.get_node("CollisionShape").disabled = false


func clear_gates():
	var upGate = self.get_node("Gates/GateUp")
	upGate.visible = false
	upGate.get_node("CollisionShape").disabled = true
	
	var downGate = self.get_node("Gates/GateDown")
	downGate.visible = false
	downGate.get_node("CollisionShape").disabled = true
	
	var leftGate = self.get_node("Gates/GateLeft")
	leftGate.visible = false
	leftGate.get_node("CollisionShape").disabled = true
	
	var rightGate = self.get_node("Gates/GateRight")
	rightGate.visible = false
	rightGate.get_node("CollisionShape").disabled = true


func no_enemies_in_room():
	var children = self.get_children()
	for child in children:
		if child.is_in_group("Enemy"):
			return false
	return true


func _on_RoomArea_body_entered(body):
	if body.is_in_group("Player"):
		pass
