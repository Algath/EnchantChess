extends Control

@onready var slot_scene = preload("res://slot.tscn")
@onready var board_grid = $ChessBoard/BoardGrid
@onready var piece_scene = preload("res://piece.tscn")
@onready var chess_board = $ChessBoard

var grid_array := []
var piece_array := []
var icon_offset := Vector2(40.5, 40.5)
var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(64):
		create_slot()

	var colorbit =0
	for i in range(8):
		for j in range(8):
			if j%2 == colorbit:
				grid_array[i*8+j].set_background(Color("696571"))
		if colorbit == 0:
			colorbit = 1
		else: colorbit = 0
		
	piece_array.resize(64)
	piece_array.fill(0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_slot():
	var new_slot = slot_scene.instantiate()
	new_slot.slot_ID = grid_array.size()
	board_grid.add_child(new_slot)
	grid_array.push_back(new_slot)
	
func add_piece(piece_type, location) -> void:
	var new_piece = piece_scene.instantiate()
	chess_board.add_child(new_piece)
	new_piece.type = piece_type
	new_piece.load_icon(piece_type)
	new_piece.global_position = grid_array[location].global_position + icon_offset
	piece_array[location] = new_piece
	new_piece.slot_ID = location

func parse_fen(fen: String) -> void:
	var boardstate = fen.split(" ")
	var board_index := 0
	for i in boardstate[0]:
		if i == "/": continue
		if i.is_valid_int():
			board_index += i.to_int()
		else:
			add_piece(DataHandler.fen_dict[i], board_index)
			board_index += 1
			
func _on_test_button_pressed() -> void:
	parse_fen(fen)
	
	
func _createServer() -> void:
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(7777, 2)
	multiplayer.multiplayer_peer = peer
	
	var ip
	for address in IP.get_local_addresses():
		if (address.split('.').size() == 4):
			ip=address
	
	print("Server started on port 7777 with IP " + ip)
	
	$IP.text = "IP : " + ip
	
	
func _connect() -> void:
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("IP_ADDRESS", 7777)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	
	
func _on_connected() -> void:
	print("Connected !")
	
func _on_connection_failed() -> void:
	print("Connection failed !")
