extends Spatial

var roomBasic = preload("res://Scenes/Rooms/RoomBasic.tscn")
var roomKey = preload("res://Scenes/Rooms/RoomKey.tscn")
var roomDoor = preload("res://Scenes/Rooms/RoomDoor.tscn")
var roomChest = preload("res://Scenes/Rooms/RoomChest.tscn")

var RoomsTextureData = [
	preload("res://Assets/BasicRoomLayouts/00.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/01.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/02.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/03.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/04.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/05.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/06.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/07.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/08.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/09.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/10.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/11.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/12.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/13.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/14.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/15.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/16.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/17.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/18.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/19.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/20.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/21.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/22.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/23.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/24.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/25.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/26.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/27.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/28.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/29.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/30.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/31.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/32.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/33.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/34.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/35.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/36.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/37.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/38.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/39.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/40.png").get_data(),
	preload("res://Assets/BasicRoomLayouts/41.png").get_data(),
	]


func create_rooms(roomCoordArray, levelnum):
	delete_rooms()
	randomize()
	var doorRoomCreated = false
	var chestRoomCreated = false
	for roomCoord in roomCoordArray:
		var r = roomBasic.instance()
		var adjacentRooms = find_adjacent_rooms(roomCoord,roomCoordArray)
		if roomCoord == [0,0]:
			r.start(coord_to_world_pos(roomCoord), adjacentRooms, levelnum, RoomsTextureData[0])
		elif roomCoord == roomCoordArray[len(roomCoordArray)-1]:
			r = roomKey.instance()
			r.start(coord_to_world_pos(roomCoord), adjacentRooms, levelnum, null)
		elif roomCoord == roomCoordArray[len(roomCoordArray)-2] and not doorRoomCreated:
			get_tree().call_group("Minimap", "add_door_icon", roomCoord)
			r = roomDoor.instance()
			r.start(coord_to_world_pos(roomCoord), adjacentRooms, levelnum, null)
		else:
			if len(adjacentRooms) == 1 and not doorRoomCreated:
				#print("door",roomCoord)
				doorRoomCreated = true
				get_tree().call_group("Minimap", "add_door_icon", roomCoord)
				r = roomDoor.instance()
				r.start(coord_to_world_pos(roomCoord), adjacentRooms, levelnum, null)
			elif len(adjacentRooms) == 1 and not chestRoomCreated and levelnum > 0:
				#print("chest",roomCoord)
				chestRoomCreated = true
				r = roomChest.instance()
				r.start(coord_to_world_pos(roomCoord), adjacentRooms, levelnum, null)
			else:
				r.start(coord_to_world_pos(roomCoord), adjacentRooms, levelnum, RoomsTextureData[rand_range(1,len(RoomsTextureData))])
		self.add_child(r)


func coord_to_world_pos(coord):
	return [coord[0]*30, coord[1]*-30]


func find_adjacent_rooms(roomCoord, roomCoordArray):
	var adjacentRooms = []
	if [roomCoord[0],roomCoord[1]+1] in roomCoordArray:
		adjacentRooms.append("up")
	if [roomCoord[0],roomCoord[1]-1] in roomCoordArray:
		adjacentRooms.append("down")
	if [roomCoord[0]-1,roomCoord[1]] in roomCoordArray:
		adjacentRooms.append("left")
	if [roomCoord[0]+1,roomCoord[1]] in roomCoordArray:
		adjacentRooms.append("right")
	return adjacentRooms


func delete_rooms():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
