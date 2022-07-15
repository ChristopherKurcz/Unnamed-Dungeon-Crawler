extends Control


func _ready():
	self.visible = false


func replay_game():
	self.visible = false
	var _connection = get_tree().create_timer(0.5).connect("timeout", self, "new_game")


func new_game():
	get_owner().start_new_game()


func go_to_menu():
	pass


func quit_game():
	get_tree().quit()


func _on_ReplayButton_pressed():
	replay_game()


func _on_MenuButton_pressed():
	go_to_menu()


func _on_QuitButton_pressed():
	quit_game()
