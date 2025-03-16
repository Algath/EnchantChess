extends Node

@onready var generate_path = preload("res://GeneratePath.gd")

# Piece arrays using ulongs (64-bit integers)
var white_pieces = [0, 0, 0, 0, 0, 0]  # bishop, king, knight, pawn, queen, rook
var black_pieces = [0, 0, 0, 0, 0, 0]  # bishop, king, knight, pawn, queen, rook

func _ready():
	pass

func _process(delta):
	pass

func get_black_bitboard():
	var ans = 0
	for i in black_pieces:
		ans |= i
	return ans

func get_white_bitboard():
	var ans = 0
	for i in white_pieces:
		ans |= i
	return ans

func clear_bitboard():
	for i in range(white_pieces.size()):
		white_pieces[i] = 0
		black_pieces[i] = 0

func set_board(whites, blacks):
	for i in range(whites.size()):
		white_pieces[i] = whites[i]
	for i in range(blacks.size()):
		black_pieces[i] = blacks[i]

# Map the PieceNames enum to the correct array index
func get_piece_index(piece_name):
	match piece_name:
		DataHandler.PieceNames.white_bishop: return 0
		DataHandler.PieceNames.white_king: return 1
		DataHandler.PieceNames.white_knight: return 2
		DataHandler.PieceNames.white_pawn: return 3
		DataHandler.PieceNames.white_queen: return 4
		DataHandler.PieceNames.white_rook: return 5
		DataHandler.PieceNames.black_bishop: return 0
		DataHandler.PieceNames.black_king: return 1
		DataHandler.PieceNames.black_knight: return 2  # Corrected typo from "balck_knight"
		DataHandler.PieceNames.black_pawn: return 3
		DataHandler.PieceNames.black_queen: return 4
		DataHandler.PieceNames.black_rook: return 5
	return -1

func is_black_piece(piece_name):
	return piece_name >= DataHandler.PieceNames.black_bishop

func init_bit_board(fen):
	clear_bitboard()
	var fen_split = fen.split(" ")
	
	for i in fen_split[0]:
		if i == '/':
			continue
		
		if i.is_valid_int():
			var shiftAmount = int(i)
			left_shift(shiftAmount)
			continue
		
		left_shift(1)
		var piece_type = DataHandler.fen_dict[i]
		
		if is_black_piece(piece_type):
			black_pieces[get_piece_index(piece_type)] |= 1 
		else:
			white_pieces[get_piece_index(piece_type)] |= 1 
	
	print("Bitboard init successfully")

func left_shift(shift_amount):
	for piece in range(black_pieces.size()):
		black_pieces[piece] <<= shift_amount
	for piece in range(white_pieces.size()):
		white_pieces[piece] <<= shift_amount

func get_bitboard():
	#print(black_pieces[4])
	return black_pieces[4]  # king and queen inversed, but not the rest of pieces, don't know why

func remove_piece(location, piece_type):
	if is_black_piece(piece_type):
		black_pieces[get_piece_index(piece_type)] &= ~(1 << location)
	else:
		white_pieces[get_piece_index(piece_type)] &= ~(1 << location)

func add_piece(location, piece_type):
	if is_black_piece(piece_type):
		black_pieces[get_piece_index(piece_type)] |= 1 << location
	else:
		white_pieces[get_piece_index(piece_type)] |= 1 << location

class Move:
	var from: int
	var to: int
	
	func _init(f, t):
		from = f
		to = t

func make_move(move, is_black_move):
	var from_list = black_pieces if is_black_move else white_pieces
	var to_list = white_pieces if is_black_move else black_pieces
	
	var from_bit = 1 << move.from
	var to_bit = 1 << move.to
	
	for i in range(6):
		to_list[i] &= ~(to_bit)  # Remove captured piece if any
	
	for i in range(6):
		if (from_list[i] & from_bit) != 0:
			from_list[i] &= ~from_bit  # Remove piece from original position
			from_list[i] |= to_bit     # Add piece to new position

func generate_move_set(is_black_move):
	var search_list
	var self_board
	var enemy_board
	var move_set = []
	var path_generator = generate_path.new()
	
	if is_black_move:
		self_board = get_black_bitboard()
		enemy_board = get_white_bitboard()
		search_list = black_pieces
	else:
		self_board = get_white_bitboard()
		enemy_board = get_black_bitboard()
		search_list = white_pieces
	
	# Bishop
	for i in range(64):
		if (search_list[0] & (1 << i)) != 0:
			var current_moves = path_generator.bishop_path(i, self_board, enemy_board, is_black_move)
			for j in range(64):
				if (current_moves & (1 << j)) != 0:
					var new_move = Move.new(i, j)
					move_set.append(new_move)
	
	# King
	#for i in range(64):
		#if (search_list[1] & (1 << i)) != 0:
			#var current_moves = path_generator.king_path(i, self_board, enemy_board, is_black_move)
			#for j in range(64):
				#if (current_moves & (1 << j)) != 0:
					#var new_move = Move.new(i, j)
					#move_set.append(new_move)
	
	# Knight
	#for i in range(64):
		#if (search_list[2] & (1 << i)) != 0:
			#var current_moves = path_generator.knight_path(i, self_board, enemy_board, is_black_move)
			#for j in range(64):
				#if (current_moves & (1 << j)) != 0:
					#var new_move = Move.new(i, j)
					#move_set.append(new_move)
	
	# Pawn
	#for i in range(64):
		#if (search_list[3] & (1 << i)) != 0:
			#var current_moves = path_generator.pawn_path(i, self_board, enemy_board, is_black_move)
			#for j in range(64):
				#if (current_moves & (1 << j)) != 0:
					#var new_move = Move.new(i, j)
					#move_set.append(new_move)
	
	# Queen
	for i in range(64):
		if (search_list[4] & (1 << i)) != 0:
			var current_moves = path_generator.queen_path(i, self_board, enemy_board, is_black_move)
			for j in range(64):
				if (current_moves & (1 << j)) != 0:
					var new_move = Move.new(i, j)
					move_set.append(new_move)
	
	# Rook
	for i in range(64):
		if (search_list[5] & (1 << i)) != 0:
			var current_moves = path_generator.rook_path(i, self_board, enemy_board, is_black_move)
			for j in range(64):
				if (current_moves & (1 << j)) != 0:
					var new_move = Move.new(i, j)
					move_set.append(new_move)
	return move_set
