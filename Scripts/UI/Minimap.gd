extends Node2D

var mapRoomBasic = preload("res://Scenes/UI/MiniMap/MapRoomBasic.tscn")
var mapArrowDown = preload("res://Scenes/UI/MiniMap/MapArrowDown.tscn")

var spaceMultiplier = 50

var roomDictionary = {} #key: roomCoord ex. [1,-2]
						#value: [(spriteNode), seenDoorway(bool), beenToRoom(bool)]
var currentCoord = [0,0]

export(float) var camAcceleration = 10
var camTargetPos = Vector2(0,0)
var camPos = Vector2(0,0)
onready var mapCam = $MiniMapCamera2D

onready var spriteHolder = $SpriteHolder


func start(roomCoordArray):
	clear_map()
	for roomCoord in roomCoordArray:
		var r = mapRoomBasic.instance()
		r.position = Vector2(roomCoord[0]*spaceMultiplier,roomCoord[1]*-spaceMultiplier)
		r.visible = false
		spriteHolder.add_child(r)
		roomDictionary[roomCoord] = [r,false,false]
#		if roomCoord == roomCoordArray[len(roomCoordArray)-2]:
#			var a = mapArrowDown.instance()
#			a.position = Vector2(roomCoord[0]*spaceMultiplier,roomCoord[1]*-spaceMultiplier)
#			a.visible = false
#			roomDictionary[roomCoord] = [r,false,false,a]
#			spriteHolder.add_child(a)
	updateMap()


func add_door_icon(roomCoord):
	var a = mapArrowDown.instance()
	a.position = Vector2(roomCoord[0]*spaceMultiplier,roomCoord[1]*-spaceMultiplier)
	a.visible = false
	roomDictionary[roomCoord] = [roomDictionary[roomCoord][0],roomDictionary[roomCoord][1],roomDictionary[roomCoord][2],a]
	spriteHolder.add_child(a)


func _physics_process(delta):
	process_camera(delta)


func process_camera(delta):
	camPos = camPos.linear_interpolate(camTargetPos, camAcceleration * delta)
	mapCam.position = camPos


func updateMap():
	updateSeenRooms()
	for x in roomDictionary:
		if roomDictionary[x][1] == true:
			roomDictionary[x][0].visible = true
		if roomDictionary[x][2] == true:
			roomDictionary[x][0].frame = 1
			if len(roomDictionary[x]) == 4:
				roomDictionary[x][3].visible = true
	roomDictionary[currentCoord][0].frame = 2
	if len(roomDictionary[currentCoord]) == 4:
		roomDictionary[currentCoord][3].visible = false


func updateSeenRooms():
	roomDictionary[currentCoord][1] = true
	roomDictionary[currentCoord][2] = true
	
	if [currentCoord[0]+1,currentCoord[1]] in roomDictionary.keys():
		roomDictionary[[currentCoord[0]+1,currentCoord[1]]][1] = true
	if [currentCoord[0]-1,currentCoord[1]] in roomDictionary.keys():
		roomDictionary[[currentCoord[0]-1,currentCoord[1]]][1] = true
	if [currentCoord[0],currentCoord[1]+1] in roomDictionary.keys():
		roomDictionary[[currentCoord[0],currentCoord[1]+1]][1] = true
	if [currentCoord[0],currentCoord[1]-1] in roomDictionary.keys():
		roomDictionary[[currentCoord[0],currentCoord[1]-1]][1] = true


func move_up():
	camTargetPos = camTargetPos + Vector2(0,-50)
	currentCoord[1] += 1
	updateMap()

func move_down():
	camTargetPos = camTargetPos + Vector2(0,50)
	currentCoord[1] -= 1
	updateMap()

func move_left():
	camTargetPos = camTargetPos + Vector2(-50,0)
	currentCoord[0] -= 1
	updateMap()

func move_right():
	camTargetPos = camTargetPos + Vector2(50,0)
	currentCoord[0] += 1
	updateMap()


func clear_map():
	currentCoord = [0,0]
	roomDictionary = {}
	camTargetPos = Vector2(0,0)
	camPos = Vector2(0,0)
	for n in spriteHolder.get_children():
		spriteHolder.remove_child(n)
		n.queue_free()
