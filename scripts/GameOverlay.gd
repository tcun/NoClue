extends Control

func _ready():
	$VBoxContainer/ResumeButton.connect("pressed", Callable(self, "_on_resume_button_pressed"))
	$VBoxContainer/SettingsButton.connect("pressed", Callable(self, "_on_overlay_settings_button_pressed"))
	$VBoxContainer/MainMenuButton.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	$VBoxContainer/ExitButton.connect("pressed", Callable(self, "_on_overlay_exit_button_pressed"))

func _on_resume_button_pressed():
	get_parent().change_state(get_parent().GameState.GAME)

func _on_overlay_settings_button_pressed():
	# Implement in-game settings logic here
	pass

func _on_main_menu_button_pressed():
	get_parent().go_to_main_menu()

func _on_overlay_exit_button_pressed():
	get_tree().quit()
