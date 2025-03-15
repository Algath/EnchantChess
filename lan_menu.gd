extends Control

var toggle_on: bool = false
var ip = ""

func _ready():
	
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4):
			ip=address
	
	$IP.text = "IP : " + ip

func _on_check_button_toggled(toggled_on: bool) -> void:
	toggle_on = toggled_on
	if (toggled_on) : #host
		$"VBoxContainer/IP address".visible = false
		$VBoxContainer/CheckButton.text = "Host"
		pass
		#CheckButton.text = "Host"
	else :
		$"VBoxContainer/IP address".visible = true
		$VBoxContainer/CheckButton.text = "Join"
		#CheckButton.text = "Join"
		pass


func _on_enter_pressed() -> void:
	
	
	
	#assert($VBoxContainer/Port != null)
	if(toggle_on == false):
		connectServer()
	else:
		createServer()
		
		#assert($"VBoxContainer/IP address" != null)
	
	#get_tree().change_scene_to_file("res://gui.tscn")
	
func createServer() -> void:
	
	var peer = ENetMultiplayerPeer.new()
	if($"VBoxContainer/Port".text == ""):
		peer.create_server(7777, 2)	
		print("Server started on port " + str(7777) +" with IP " + ip)
	else:
		peer.create_server(int($"VBoxContainer/Port".text), 2)
		print("Server started on port " + $"VBoxContainer/Port".text +" with IP " + ip)
		
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	
	
	
func connectServer() -> void:
	
	var peer = ENetMultiplayerPeer.new()
	if($"VBoxContainer/Port".text == ""):
		peer.create_client($"VBoxContainer/IP address".text, 7777)
	else:
		peer.create_client($"VBoxContainer/IP address".text, int($"VBoxContainer/Port".text))

	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	
	
func _on_connected() -> void:
	print("Connected !")
	get_tree().change_scene_to_file("res://gui.tscn")
	
func _on_player_connected(id):
	print("Peer is connected : " + str(id))
	get_tree().change_scene_to_file("res://gui.tscn")
	
func _on_connection_failed() -> void:
	print("Connection failed !")
