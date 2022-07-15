extends Control

var hearts = 3 setget set_hearts
var max_hearts = 3 setget set_max_hearts

onready var heartUIFull = $HeartsFull
onready var heartUIEmpty = $HeartsEmpty

func _ready():
	self.max_hearts = PlayerStats.MAXHEALTH
	self.hearts = PlayerStats.health
	var _healthConnect = PlayerStats.connect("health_changed", self, "set_hearts")
	var _maxHealthConnect = PlayerStats.connect("max_health_changed", self, "set_max_hearts")

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 8

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 8
