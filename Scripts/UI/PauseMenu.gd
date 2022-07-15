extends Control

var gamePaused = false


func _ready():
	self.visible = false
	gamePaused = false


func _process(_delta):
	process_input()


func process_input():
	if Input.is_action_just_pressed("pause_game") and not gamePaused and PlayerStats.active:
		pause_game()
	elif Input.is_action_just_pressed("pause_game") and gamePaused:
		resume_game()


func pause_game():
	get_tree().paused = true
	gamePaused = true
	show_pause_menu()


func resume_game():
	get_tree().paused = false
	gamePaused = false
	hide_pause_menu()


func quit_game():
	get_tree().quit()


func go_to_menu():
	pass


func show_pause_menu():
	get_parent().get_node("MessageUI").visible = false
	self.visible = true
	update_stats()
	if PlayerStats.currentItem != null:
		show_item_tooltip()
	else:
		hide_item_tooltip()


func hide_pause_menu():
	get_parent().get_node("MessageUI").visible = true
	self.visible = false


func show_item_tooltip():
	if PlayerStats.currentItem == "Clover":
		$ItemNameLabel.text = "Lucky Clover"
		$ItemDescLabel.text = "Increases chances of enemies dropping orbs on death and hearts appearing when a room is cleared"
	if PlayerStats.currentItem == "Arrow":
		$ItemNameLabel.text = "Needle Arrow"
		$ItemDescLabel.text = "Enemy piercing Shots"
	if PlayerStats.currentItem == "MultiShot":
		$ItemNameLabel.text = "MultiShot"
		$ItemDescLabel.text = "Shoot in all four directions"
	if PlayerStats.currentItem == "Boomerang":
		$ItemNameLabel.text = "Boomerang"
		$ItemDescLabel.text = "Shots fly back towards you"
	if PlayerStats.currentItem == "Wings":
		$ItemNameLabel.text = "Spirit Wings"
		$ItemDescLabel.text = "Fly over spikes"
	$ItemNameLabel.visible = true
	$ItemDescLabel.visible = true

func hide_item_tooltip():
	$ItemNameLabel.visible = false
	$ItemDescLabel.visible = false


func update_stats():
	$StatsDescLabel.text = (str(PlayerStats.SPEED)+"\n"+str(PlayerStats.FIRERATE)+"\n"+str(PlayerStats.BULLETSPEED)+"\n"+str(PlayerStats.KNOCKSTRENGTH)+"\n"+str(PlayerStats.BULLETDISTANCE))


func _on_ResumeButton_pressed():
	resume_game()


func _on_QuitButton_pressed():
	quit_game()


func _on_MenuButton_pressed():
	go_to_menu()
