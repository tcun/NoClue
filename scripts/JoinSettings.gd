extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/JoinServerButton.connect("pressed", Callable(self, "_on_join_server_button_pressed"))
	$VBoxContainer/ErrorMessage.text = ""

func _on_join_server_button_pressed():
	var ip = $VBoxContainer/Ip.text
	var port_text = $VBoxContainer/Port.text

	if port_text.is_valid_int():
		var port = port_text.to_int()
		if port > 0 and port < 65536:
			if Network.join_server(ip, port):
				$VBoxContainer/ErrorMessage.text = ""
				#get_parent().start_game()
			else:
				$VBoxContainer/ErrorMessage.text = "Failed to connect to server. Check console for details."
		else:
			$VBoxContainer/ErrorMessage.text = "Invalid port number. Please enter a number between 1 and 65535."
	else:
		$VBoxContainer/ErrorMessage.text = "Invalid port number. Please enter a valid number."
