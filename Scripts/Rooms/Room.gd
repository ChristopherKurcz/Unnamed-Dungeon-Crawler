extends Spatial

var roomPos
var adjRooms = []

var levelnum


func start(roomPosition, adjacentRooms, levelnumber, _roomData):
	levelnum = levelnumber
	roomPos = roomPosition
	adjRooms = adjacentRooms
	self.transform.origin = Vector3(roomPos[0],0,roomPos[1])
	create_fill_walls()


func create_fill_walls():
	if not "up" in adjRooms:
		var upFillWall = self.get_node("FillWalls/WallUp")
		upFillWall.visible = true
		upFillWall.get_node("CollisionShape").disabled = false
	if not "down" in adjRooms:
		var downFillWall = self.get_node("FillWalls/WallDown")
		downFillWall.visible = true
		downFillWall.get_node("CollisionShape").disabled = false
	if not "left" in adjRooms:
		var leftFillWall = self.get_node("FillWalls/WallLeft")
		leftFillWall.visible = true
		leftFillWall.get_node("CollisionShape").disabled = false
	if not "right" in adjRooms:
		var rightFillWall = self.get_node("FillWalls/WallRight")
		rightFillWall.visible = true
		rightFillWall.get_node("CollisionShape").disabled = false


func _on_DoorUp_body_entered(body):
	if body.is_in_group("Player"):
		body.global_transform.origin = self.global_transform.origin + Vector3(0,0.5,-25)
		body.moveVel = Vector3.ZERO
		PlayerStats.active = false
		var _connection = get_tree().create_timer(0.2).connect("timeout", self, "set_player_active")
		get_tree().call_group("Camera", "move_up")

func _on_DoorDown_body_entered(body):
	if body.is_in_group("Player"):
		body.global_transform.origin = self.global_transform.origin + Vector3(0,0.5,25)
		body.moveVel = Vector3.ZERO
		PlayerStats.active = false
		var _connection = get_tree().create_timer(0.2).connect("timeout", self, "set_player_active")
		get_tree().call_group("Camera", "move_down")

func _on_DoorLeft_body_entered(body):
	if body.is_in_group("Player"):
		body.global_transform.origin = self.global_transform.origin + Vector3(-23,0.5,0)
		body.moveVel = Vector3.ZERO
		PlayerStats.active = false
		var _connection = get_tree().create_timer(0.2).connect("timeout", self, "set_player_active")
		get_tree().call_group("Camera", "move_left")

func _on_DoorRight_body_entered(body):
	if body.is_in_group("Player"):
		body.global_transform.origin = self.global_transform.origin + Vector3(23,0.5,0)
		body.moveVel = Vector3.ZERO
		PlayerStats.active = false
		var _connection = get_tree().create_timer(0.2).connect("timeout", self, "set_player_active")
		get_tree().call_group("Camera", "move_right")


func set_player_active():
	PlayerStats.active = true
