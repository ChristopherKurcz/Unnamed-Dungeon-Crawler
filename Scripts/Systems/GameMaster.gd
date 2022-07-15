extends Spatial

onready var roomGenerator = $RoomGenerator
onready var effectsHandler = $EffectsHandler
onready var miniMap = $GUI/ViewportContainer/Viewport/Minimap
onready var player = null
onready var cameraRig = $CameraRig
onready var backgroundMusic = $BackgroundMusic

var levelNum = 0

var PlayerRefernce = preload("res://Scenes/Player/PlayerGhost.tscn")

#debug
var enter_new_level = true

func _ready():
	start_new_game()

func start_new_game():
	backgroundMusic.play()
	levelNum = 0
	randomize()
	PlayerStats.reset_stats()
	create_player()
	create_new_level()
	effectsHandler.startup()


func _process(_delta):
	if enter_new_level and Input.is_key_pressed(KEY_ENTER):
		levelNum += 1
		create_new_level()


func create_player():
	var p
	p = PlayerRefernce.instance()
	self.add_child(p)
	player = p


func create_new_level():
	cameraRig.targetPos = Vector3.ZERO
	cameraRig.pos = Vector3.ZERO
	player.global_transform.origin = Vector3(0,0.5,0)
	player.stats.hasKey = false
	var numRooms = 5 + min(levelNum,12)*2 + (randi()%3)
	var roomCoordArray = generate_room_cords(numRooms)
	#print(roomCoordArray)
	roomGenerator.create_rooms(roomCoordArray, levelNum)
	miniMap.start(roomCoordArray)
	levelNum += 1


func generate_room_cords(numRooms):
	#generates an array of coordinates for interconnecting rooms, numRooms is number of rooms to make
	var result = [[0,0]]
	for _x in range(numRooms-1):
		var availableRooms = generate_adjacent_coords(result)
		var rand = rand_range(0,len(availableRooms))
		result.append(availableRooms[rand])
	return result


func generate_adjacent_coords(coordsArray):
	var result = []
	for coord in coordsArray:
		var up = [coord[0],coord[1]+1]
		var down = [coord[0],coord[1]-1]
		var left = [coord[0]-1,coord[1]]
		var right = [coord[0]+1,coord[1]]
		if not up in result and not up in coordsArray:
			result.append(up)
		if not down in result and not down in coordsArray:
			result.append(down)
		if not left in result and not left in coordsArray:
			result.append(left)
		if not right in result and not right in coordsArray:
			result.append(right)
	return result


func door_entered():
	PlayerStats.add_to_score(100*(levelNum+1))
	effectsHandler.transition_out()


func game_over():
	effectsHandler.game_over_effects()
	backgroundMusic.stop()
