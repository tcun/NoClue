extends Control

func _ready():
	$VBoxContainer/StartButton.connect("pressed", Callable(self, "_on_start_button_pressed"))
	$VBoxContainer/SettingsButton.connect("pressed", Callable(self, "_on_settings_button_pressed"))
	$VBoxContainer/ExitButton.connect("pressed", Callable(self, "_on_exit_button_pressed"))

func _on_start_button_pressed():
	get_parent().go_to_lobby()

func _on_settings_button_pressed():
	# Implement settings logic here
	pass

func _on_exit_button_pressed():
	get_tree().quit()
