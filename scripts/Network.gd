extends Node

var server: ENetMultiplayerPeer
var client: ENetMultiplayerPeer
var players = {}

func start_server(port: int) -> bool:
	server = ENetMultiplayerPeer.new()
	
	var error = server.create_server(port, 4) # Allow up to 4 players
	if error != OK:
		print("Error creating server: ", error)
		return false
	
	multiplayer.multiplayer_peer = server
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	print("Server started on port ", port)
	load_game_scene()
	return true

func join_server(ip: String, port: int) -> bool:
	client = ENetMultiplayerPeer.new()
	var error = client.create_client(ip, port) # Connect to server with given IP and port
	if error != OK:
		print("Error connecting to server: ", error)
		return false

	multiplayer.multiplayer_peer = client
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connection_succeeded)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	print("Connecting to server...")
	return true

func _on_peer_connected(id: int):
	print("Player connected with id: ", id)
	rpc("broadcast_message", "Player " + str(id) + " has connected.")
	
	if is_multiplayer_authority():
		var player = _instantiate_player(id)
		players[id] = player
		rpc_id(id, "set_player_id", id)

func _on_peer_disconnected(id: int):
	print("Player disconnected with id: ", id)
	rpc("broadcast_message", "Player " + str(id) + " has disconnected.")
	if id in players:
		players[id].queue_free()
		players.erase(id)

func _on_connection_succeeded():
	print("Successfully connected to the server!")
	rpc_id(1, "broadcast_message", "A new player has connected.") # Assuming server ID is 1
	load_game_scene()

func _on_connection_failed():
	print("Failed to connect to the server.")

func _on_server_disconnected():
	print("Disconnected from server.")
	
@rpc
func broadcast_message(message: String):
	print(message)

@rpc
func set_player_id(id: int):
	var player = _instantiate_player(id)
	players[id] = player

func load_game_scene():
	# Load the scene resource
	var game_scene = ResourceLoader.load("res://scenes/base.tscn")
	if game_scene == null:
		push_error("Failed to load scene: res://scenes/base.tscn")
		return
	
	# Instantiate the scene
	var game_instance = game_scene.instantiate()
	if game_instance == null:
		push_error("Failed to instantiate scene: res://scenes/base.tscn")
		return

	# Optional: Remove the current scene if necessary
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()
	
	# Add the instantiated scene to the current scene tree
	get_tree().root.add_child(game_instance)
	get_tree().current_scene = game_instance
	game_instance.name = "GameInstance"
	
	# Set mouse mode to captured after scene switch
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _instantiate_player(id: int):
	var player_scene = preload("res://scenes/Player.tscn")
	var player = player_scene.instantiate()
	player.set_multiplayer_authority(id)
	get_tree().current_scene.add_child(player)
	return player
