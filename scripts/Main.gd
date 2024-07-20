extends Control

# Define the possible game states
enum GameState { MAIN_MENU, LOBBY, GAME, PAUSE, HOST }
var current_state = GameState.MAIN_MENU

# Declare node references with onready to ensure they're assigned when the scene is ready
@onready var main_menu = $MainMenu
@onready var lobby = $Lobby
@onready var game_overlay = $GameOverlay
@onready var host_settings = $HostSettings

# Called when the node is added to the scene
func _ready():
	change_state(GameState.MAIN_MENU)

# Change the current state and update the UI accordingly
func change_state(new_state):
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)

# Enter a new state and make the corresponding UI elements visible
func enter_state(state):
	match state:
		GameState.MAIN_MENU:
			main_menu.visible = true
			lobby.visible = false
			game_overlay.visible = false
		GameState.LOBBY:
			main_menu.visible = false
			lobby.visible = true
		GameState.GAME:
			main_menu.visible = false
			lobby.visible = false
			game_overlay.visible = false
			host_settings.visible = false
			load_game_scene()
		GameState.PAUSE:
			game_overlay.visible = true
			get_tree().paused = true
		GameState.HOST:
			lobby.visible = false
			host_settings.visible = true

# Exit the current state and perform necessary cleanup
func exit_state(state):
	match state:
		GameState.MAIN_MENU:
			pass
		GameState.LOBBY:
			pass
		GameState.GAME:
			unload_game_scene()
		GameState.PAUSE:
			game_overlay.visible = false
			get_tree().paused = false

# Load the game scene and add it to the current scene tree
#func load_game_scene():
	## Load the scene resource
	#var game_scene = ResourceLoader.load("res://scenes/base.tscn")
	#if game_scene == null:
		#push_error("Failed to load scene: res://scenes/base.tscn")
		#return
	#
	## Instantiate the scene
	#var game_instance = game_scene.instantiate()
	#if game_instance == null:
		#push_error("Failed to instantiate scene: res://scenes/base.tscn")
		#return
#
	## Optional: Remove the current scene if necessary
	#var current_scene = get_tree().current_scene
	#if current_scene:
		#current_scene.queue_free()
	#
	## Add the instantiated scene to the current scene tree
	#get_tree().root.add_child(game_instance)
	#get_tree().current_scene = game_instance
	#game_instance.name = "GameInstance"
	#
	## Set mouse mode to captured after scene switch
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Unload the game scene by freeing the game instance
func unload_game_scene():
	var game_instance = get_node("GameInstance")
	if game_instance:
		game_instance.queue_free()

# Functions to change states, can be called from button scripts or other triggers
func go_to_main_menu():
	change_state(GameState.MAIN_MENU)

func go_to_lobby():
	change_state(GameState.LOBBY)
	
func go_to_host():
	change_state(GameState.HOST)

func start_game():
	change_state(GameState.GAME)

func pause_game():
	change_state(GameState.PAUSE)
