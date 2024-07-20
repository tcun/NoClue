extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartServerButton.connect("pressed", Callable(self, "_on_start_server_button_pressed"))
	$VBoxContainer/ErrorMessage.text = ""

func _on_start_server_button_pressed():
	var port_text = $VBoxContainer/Port.text
	var port = int(port_text)

	if port > 0 and port < 65536:
		if Network.start_server(port):
			$VBoxContainer/ErrorMessage.text = ""
			get_parent().start_game()
		else:
			$VBoxContainer/ErrorMessage.text = "Failed to start server. Check console for details."
	else:
		$VBoxContainer/ErrorMessage.text = "Invalid port number. Please enter a number between 1 and 65535."

