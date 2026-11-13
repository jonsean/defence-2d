extends Node

var PORT = 8910
var DEFAULT_SERVER_IP = "127.0.0.1" # Localhost for testing

@export var player_scene: PackedScene

@onready var menu: Control = $UI/MainMenu
@onready var players_container: Node = $World/Players

func _ready() -> void:
	%PortLabel.text = str(PORT)
	Events.host_button_signal.connect(_on_host_pressed)
	Events.join_button_signal.connect(_on_join_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		%MainMenu.visible = !%MainMenu.visible

# Call this when the user clicks a "Host" button in your UI
func _on_host_pressed(port) -> void:
	PORT = port
	%PortLabel.text = str(PORT)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 4) # Max 4 players
	if error != OK:
		print("Failed to host: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	menu.hide() # Hide lobby UI once connected
	
	# Connect signals to handle players joining and leaving
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	Global.isHost = true
	Global.isClient = false
	# The host spawns their own player locally
	_on_peer_connected(1)

# Call this when the user clicks a "Join" button in your UI
func _on_join_pressed(ip: String = DEFAULT_SERVER_IP) -> void:
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, PORT)
	if error != OK:
		print("Failed to join: ", error)
		return
	%AdressLabel.text = ip
	multiplayer.multiplayer_peer = peer
	menu.hide()
	
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	Global.isClient = true
	Global.isHost = false

func _on_connected_to_server() -> void:
	print("Successfully connected to the server!")

func _on_connection_failed() -> void:
	print("Connection failed.")
	menu.show()
	multiplayer.multiplayer_peer = null

# SERVER ONLY: When a peer connects, the server instantiates their player
func _on_peer_connected(id: int) -> void:
	print("Player connected: ", id)
	
	# Only the server should spawn networked objects using add_child()
	if multiplayer.is_server():
		var player_instance = player_scene.instantiate()
		player_instance.name = str(id) # Crucial: Name the node after the peer ID for synchronization
		players_container.add_child(player_instance, true)

# SERVER ONLY: When a peer disconnects, remove their player
func _on_peer_disconnected(id: int) -> void:
	print("Player disconnected: ", id)
	if multiplayer.is_server():
		var player_node = players_container.get_node_or_null(str(id))
		if player_node:
			player_node.queue_free()
