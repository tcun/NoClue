extends Control

func _ready():
	# Use get_node_or_null to safely get the nodes and check if they exist
	var single_player_button = $VBoxContainer/SingePlayerButton
	var host_game_button = $VBoxContainer/HostGameButton
	var join_game_button = $VBoxContainer/JoinGameButton

	if single_player_button:
		single_player_button.connect("pressed", Callable(self, "_on_single_player_button_pressed"))
	else:
		print("Error: SinglePlayerButton node not found")

	if host_game_button:
		host_game_button.connect("pressed", Callable(self, "_on_host_game_button_pressed"))
	else:
		print("Error: HostGameButton node not found")

	if join_game_button:
		join_game_button.connect("pressed", Callable(self, "_on_join_game_button_pressed"))
	else:
		print("Error: JoinGameButton node not found")

func _on_single_player_button_pressed():
	get_parent().start_game()

func _on_host_game_button_pressed():
	get_parent().go_to_host();
	pass

func _on_join_game_button_pressed():
	# Implement join game logic here
	pass
