extends Control

var toggle_on: bool = false

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
	peer.create_server(int($"VBoxContainer/Port".text), 2)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	
	var ip
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4):
			ip=address
	
	print("Server started on port " + $"VBoxContainer/Port".text +" with IP " + ip)
	
	$IP.text = "IP : " + ip
	
	
	
func connectServer() -> void:
	
	var peer = ENetMultiplayerPeer.new()
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
