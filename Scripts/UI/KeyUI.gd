extends Control

var hasKey = false setget set_hasKey

onready var keyUIFull = $KeyFull
onready var keyUIEmpty = $KeyEmpty

func _ready():
	self.hasKey = PlayerStats.hasKey
	var _hasKeyConnect = PlayerStats.connect("hasKey_changed", self, "set_hasKey")

func set_hasKey(value):
	hasKey = value
	if hasKey:
		keyUIFull.visible = true
	else:
		keyUIFull.visible = false
