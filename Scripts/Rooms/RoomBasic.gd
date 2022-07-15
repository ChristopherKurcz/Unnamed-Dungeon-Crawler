extends "res://Scripts/Rooms/Room.gd"

var roomData

var hasEnemies = false

var Spike = preload("res://Scenes/Collisions/Spike.tscn")
var Skel = preload("res://Scenes/Enemies/Skel.tscn")
var Bat = preload("res://Scenes/Enemies/Bat.tscn")
var Clop = preload("res://Scenes/Enemies/Clop.tscn")
var Blob = preload("res://Scenes/Enemies/Blob.tscn")
var Wati = preload("res://Scenes/Enemies/Wati.tscn")
var Gnom = preload("res://Scenes/Enemies/Gnom.tscn")
var EnemyChest = preload("res://Scenes/Enemies/EnemyChest.tscn")

onready var roomArea = $RoomArea
onready var animPlayer = $AnimationPlayer
onready var heartArea = $HeartArea

var heartDropPercentChance = 30 + PlayerStats.LUCK


func start(roomPosition, adjacentRooms, levelnum, roomsTextureData):
	randomize()
	roomData = roomsTextureData
	.start(roomPosition, adjacentRooms, levelnum, roomsTextureData)
	fill_room()


func fill_room():
	for x in range(0,14):
		for y in range(0,10):
			roomData.lock()
			var cellData = roomData.get_pixel(1+x, 1+y)
			var cellCoords = [-6.5+x, -4.5+y]
			cellData[0] = stepify(cellData[0],0.1)
			if cellData == Color.black:
				var s = Spike.instance()
				s.translation = Vector3(cellCoords[0], 0.5, cellCoords[1])
				self.add_child(s)
			if cellData == Color.blue:
				var b = Bat.instance()
				spawn_enemy(b, cellCoords)
			if cellData == Color.green:
				var s = Skel.instance()
				spawn_enemy(s, cellCoords)
			if cellData == Color.red:
				var c = Clop.instance()
				spawn_enemy(c, cellCoords)
			if cellData == Color.yellow:
				var b = Blob.instance()
				spawn_enemy(b, cellCoords)
			if cellData == Color.aqua:
				var w = Wati.instance()
				spawn_enemy(w, cellCoords)
			if cellData == Color.chartreuse:
				var c = EnemyChest.instance()
				spawn_enemy(c, cellCoords)
			if cellData == Color.fuchsia:
				var g = Gnom.instance()
				spawn_enemy(g, cellCoords)


func spawn_enemy(enemy, cellCoords):
	enemy.start(Vector3(cellCoords[0], 0.5, cellCoords[1]), levelnum)
	self.add_child(enemy)
	hasEnemies = true


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


func spawn_heart():
	heartArea.visible = true
	$HeartArea/AnimationPlayer.play("HeartSpawn")

func place_heart():
	$HeartArea/CollisionShape.disabled = false
	$HeartArea/AnimationPlayer.play("HeartIdle")

func heartPickedUp():
	$HeartArea/AnimationPlayer.play("HeartAquired")
	$HeartArea/CollisionShape.disabled = true


func no_enemies_in_room():
	var children = self.get_children()
	for child in children:
		if child.is_in_group("Enemy"):
			return false
	return true


func _on_RoomArea_body_entered(body):
	if body.is_in_group("Player"):
		if hasEnemies:
			close_gates()


func _on_RoomArea_body_exited(body):
	if body.is_in_group("Enemy"):
		var _connection = get_tree().create_timer(1).connect("timeout", self, "check_for_enemies")


func check_for_enemies():
	if no_enemies_in_room():
		hasEnemies = false
		animPlayer.play("GatesOpen")
		
		if randi()%100 <= heartDropPercentChance:
			spawn_heart()
		
		PlayerStats.add_to_score(50)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "GatesOpen":
		clear_gates()
	if anim_name == "HeartSpawn":
		place_heart()
