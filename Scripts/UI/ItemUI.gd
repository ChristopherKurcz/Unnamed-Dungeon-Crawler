extends Control

onready var cloverUI = $CloverUI
onready var arrowUI = $ArrowUI
onready var multiShotUI = $MultiShotUI
onready var boomerangUI = $BoomerangUI
onready var wingsUI = $WingsUI

func _ready():
	set_item(PlayerStats.currentItem)


func set_item(item):
	cloverUI.visible = (item == "Clover")
	arrowUI.visible = (item == "Arrow")
	multiShotUI.visible = (item == "MultiShot")
	boomerangUI.visible = (item == "Boomerang")
	wingsUI.visible = (item == "Wings")
