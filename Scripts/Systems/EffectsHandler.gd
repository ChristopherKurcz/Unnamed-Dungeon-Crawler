extends Spatial

onready var GUI = get_parent().get_node("GUI")
onready var Palettes = get_parent().get_node("Palettes")
onready var tween1 = $Tween1
onready var tween2 = $Tween2

var paletteArray = []
var currentPalette = 0
var paletteFadeTime = 2


func _ready():
	set_palette(0)


func startup():
	paletteArray = Palettes.get_children()
	
	GUI.get_node("TransitionColorRect").visible = true
	GUI.get_node("TransitionColorRect").color = Color.black
	GUI.get_node("BigMessageUI").visible = true
	GUI.get_node("ItemUI").set_item(PlayerStats.currentItem)
	
	var message = "Floor "+String(get_parent().levelNum)
	get_tree().call_group("BigMessageUI", "create_message", message)
	
	if currentPalette != 0:
		var _connection = get_tree().create_timer(1).connect("timeout", self, "fade_palettes",[0])
	var _connection = get_tree().create_timer(5).connect("timeout", self, "transition_in")


func transition_out():
	PlayerStats.active = false
	GUI.get_node("TransitionColorRect").visible = true
	GUI.get_node("BigMessageUI").visible = true
	GUI.get_node("TransitionColorRect/TransitionAnimationPlayer").play("TransitionOut")


func transition_in():
	GUI.get_node("TransitionColorRect/TransitionAnimationPlayer").play("TransitionIn")


func game_over_effects():
	GUI.get_node("GameOverMenu/ScoreLabel").text = "SCORE: "+str(PlayerStats.score)
	GUI.get_node("TransitionColorRect").visible = true
	GUI.get_node("TransitionColorRect/TransitionAnimationPlayer").play("GameOver")


func switch_palettes():
	randomize()
	var nextPalette = currentPalette
	while currentPalette == nextPalette or nextPalette == 0:
		nextPalette = randi()%len(paletteArray)
	
	fade_palettes(nextPalette)


func fade_palettes(nextPalette):
	paletteArray[nextPalette].modulate = Color(1, 1, 1, 0)
	paletteArray[nextPalette].visible = true
	tween1.interpolate_property(paletteArray[currentPalette], "modulate", 
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), paletteFadeTime, 
		Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween2.interpolate_property(paletteArray[nextPalette], "modulate", 
		Color(1, 1, 1, 0), Color(1, 1, 1, 1), paletteFadeTime, 
		Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween1.start()
	tween2.start()
	var _connection = get_tree().create_timer(paletteFadeTime).connect("timeout", self, "set_palette", [nextPalette])


func set_palette(paletteNum):
	for x in range(0,len(paletteArray)):
		if paletteNum == x:
			paletteArray[x].visible = true
			currentPalette = paletteNum
		else:
			paletteArray[x].visible = false


func _on_TransitionAnimationPlayer_animation_finished(anim_name):
	if anim_name == "TransitionOut":
		get_parent().create_new_level()
		var message = "Floor "+String(get_parent().levelNum)
		get_tree().call_group("BigMessageUI", "create_message", message)
		var _connection = get_tree().create_timer(1).connect("timeout", self, "switch_palettes")
		_connection = get_tree().create_timer(5).connect("timeout", self, "transition_in")
	
	if anim_name == "TransitionIn":
		GUI.get_node("TransitionColorRect").visible = false
		GUI.get_node("BigMessageUI").visible = false
		PlayerStats.active = true
	
	if anim_name == "GameOver":
		GUI.get_node("GameOverMenu").visible = true
