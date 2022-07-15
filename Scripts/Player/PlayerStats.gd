extends Node

var SPEED = 4
var ACCELERATION = 6
var FIRERATE = 1
var MAXHEALTH = 6 setget set_max_health
var LUCK = 0

var BULLETSPEED = 6
var KNOCKSTRENGTH = 1
var BULLETDISTANCE = 5
var BULLETPIERCING = false
var MULTISHOT = false
var BOOMERANG = false
var WINGS = false

onready var health = MAXHEALTH setget set_health

var score = 0
var SCOREMULTIPLIER = 1

var hasKey = false setget set_hasKey
var currentItem

var active = false

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal hasKey_changed(value)


func reset_stats():
	SPEED = 4
	ACCELERATION = 6
	FIRERATE = 2
	MAXHEALTH = 6
	LUCK = 0
	BULLETSPEED = 6
	KNOCKSTRENGTH = 0
	BULLETDISTANCE = 5
	SCOREMULTIPLIER = 1
	reset_items()
	set_max_health(6)
	set_health(6)
	set_score(0)


func set_max_health(value):
	MAXHEALTH = value
	if(health != null):
		self.health = min(health, MAXHEALTH)
	emit_signal("max_health_changed", MAXHEALTH)

func set_health(value):
	if value >= MAXHEALTH:
		value = MAXHEALTH
	health = value
	emit_signal("health_changed", health)
	if (health <= 0):
		emit_signal("no_health")

func set_hasKey(value):
	hasKey = value
	emit_signal("hasKey_changed", hasKey)


func set_score(num):
	score = num


func add_to_score(num):
	score += num * SCOREMULTIPLIER


func orb_pickup():
	randomize()
	var r = randi()%5 + 1
	
	var maxUP = randi()%(MAXHEALTH*2) + 1
	if maxUP == 1 and MAXHEALTH < 16:
		r = 0
		MAXHEALTH += 2
		set_max_health(MAXHEALTH)
		get_tree().call_group("MessageUI", "create_message", "MAX HEALTH UP")
	
	if r == 1:
		SPEED += 0.2
		get_tree().call_group("MessageUI", "create_message", "SPEED UP")
	if r == 2:
		FIRERATE += 0.2
		get_tree().call_group("MessageUI", "create_message", "FIRERATE UP")
	if r == 3:
		BULLETSPEED += 0.5
		get_tree().call_group("MessageUI", "create_message", "SHOT SPEED UP")
	if r == 4:
		KNOCKSTRENGTH += 0.1
		get_tree().call_group("MessageUI", "create_message", "KNOCKBACK UP")
	if r == 5:
		BULLETDISTANCE += 0.5
		get_tree().call_group("MessageUI", "create_message", "RANGE UP")


func reset_items():
	currentItem = null
	LUCK = 0
	BULLETPIERCING = false
	MULTISHOT = false
	BOOMERANG = false
	WINGS = false


func pickup_clover():
	reset_items()
	get_tree().call_group("ItemUI", "set_item", "Clover")
	get_tree().call_group("MessageUI", "create_message", "Lucky Clover Aquired")
	currentItem = "Clover"
	LUCK = 7


func pickup_arrow():
	reset_items()
	get_tree().call_group("ItemUI", "set_item", "Arrow")
	get_tree().call_group("MessageUI", "create_message", "Needle Arrow Aquired")
	currentItem = "Arrow"
	BULLETPIERCING = true


func pickup_multishot():
	reset_items()
	get_tree().call_group("ItemUI", "set_item", "MultiShot")
	get_tree().call_group("MessageUI", "create_message", "MultiShot Aquired")
	currentItem = "MultiShot"
	MULTISHOT = true


func pickup_boomerang():
	reset_items()
	get_tree().call_group("ItemUI", "set_item", "Boomerang")
	get_tree().call_group("MessageUI", "create_message", "Boomerang Aquired")
	currentItem = "Boomerang"
	BOOMERANG = true


func pickup_wings():
	reset_items()
	get_tree().call_group("ItemUI", "set_item", "Wings")
	get_tree().call_group("MessageUI", "create_message", "Spirit Wings Aquired")
	currentItem = "Wings"
	WINGS = true
