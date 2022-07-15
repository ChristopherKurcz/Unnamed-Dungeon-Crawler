extends Control

var MessageLabel = preload("res://Scenes/UI/BigMessageUILabel.tscn")

onready var vboxContainer = $VBoxContainer

func create_message(messageText):
	var m = MessageLabel.instance()
	m.text = messageText
	vboxContainer.add_child(m)
	vboxContainer.margin_bottom = 0
