extends Node

func _ready():
	pass

func _process(delta):
	pass

func rook_path(rook_position, self_board, enemy_board, is_black):
	var legal_moves = 0
	# Calculate moves to the right
	for i in range(rook_position + 1, 64):
		if i % 8 == 0:  # Reached right edge
			break
		# Check if the spot is occupied by an enemy
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		# Check if the spot is occupied by self
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	# Moves to the left
	for i in range(rook_position - 1, -1, -1):
		if i % 8 == 7:  # Reached left edge (wrapped around)
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	# Moves upward
	for i in range(rook_position + 8, 64, 8):
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	# Moves downward
	for i in range(rook_position - 8, -1, -8):
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	return legal_moves

func knight_path(knight_position, self_board, enemy_board, is_black):
	var knight_mask = 43234889994
	var shift_amount = knight_position - 18
	
	if shift_amount >= 0:
		knight_mask <<= shift_amount
	else:
		knight_mask >>= -shift_amount
	
	if knight_position % 8 > 5:
		knight_mask &= ~0x303030303030303
	
	if knight_position % 8 < 2:
		knight_mask &= ~0x4040404040404040
	
	knight_mask ^= self_board & knight_mask
	return knight_mask

func bishop_path(bishop_position, self_board, enemy_board, is_black):
	var legal_moves = 0
	
	# Calculate moves to the top left (diagonal)
	for i in range(bishop_position + 9, 64, 9):
		if i % 8 == 0:  # Reached right edge
			break
		# Check if the spot is occupied by an enemy
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		# Check if the spot is occupied by self
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	# Moves to the top right (diagonal)
	for i in range(bishop_position + 7, 64, 7):
		if i % 8 == 7:  # Reached left edge
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	# Moves to the bottom left (diagonal)
	for i in range(bishop_position - 7, -1, -7):
		if i % 8 == 0:  # Reached right edge
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	# Moves to the bottom right (diagonal)
	for i in range(bishop_position - 9, -1, -9):
		if i % 8 == 7:  # Reached left edge
			break
		if (enemy_board & (1 << i)) != 0:
			legal_moves |= 1 << i
			break
		if (self_board & (1 << i)) != 0:
			break
		legal_moves |= 1 << i
	
	return legal_moves

func queen_path(queen_position, self_board, enemy_board, is_black):
	var legal_moves = 0
	legal_moves = bishop_path(queen_position, self_board, enemy_board, is_black) | rook_path(queen_position, self_board, enemy_board, is_black)
	return legal_moves

func king_path(king_position, self_board, enemy_board, is_black):
	var king_mask = 460039
	var shift_amount = king_position - 9
	
	if shift_amount >= 0:
		king_mask <<= shift_amount
	else:
		king_mask >>= -shift_amount
	
	if king_position % 8 > 6:
		king_mask &= ~0x303030303030303
	
	if king_position % 8 < 1:
		king_mask &= ~0x4040404040404040
	
	king_mask ^= self_board & king_mask
	return king_mask

func pawn_path(pawn_position, self_board, enemy_board, is_black):
	var pawn_mask = 0
	var attack_mask := 0
	
	if is_black:
		if pawn_position >= 47 and pawn_position < 56:
			# pawn_mask for black set at position 63
			pawn_mask = 0x80800000000000
		else:
			pawn_mask = 0x80000000000000
		
		pawn_mask >>= 63 - pawn_position
		
		# Check if there is a piece blocking, if so, cancel the two step movement
		if ((self_board | enemy_board) & (1 << (pawn_position - 8))) != 0:
			pawn_mask = 0
		
		attack_mask = 0xA0000000000000
		# attackMask preset the pawn position at 62
		if pawn_position == 63:
			attack_mask <<= 1
		else:
			attack_mask >>= 62 - pawn_position
	else:
		if pawn_position >= 7 and pawn_position < 16:
			# pawnMask for white set at position 0
			pawn_mask = 0x10100
		else:
			pawn_mask = 0x100
		
		attack_mask = 0x500
		pawn_mask <<= pawn_position
		
		# Check if there is a piece blocking, if so, cancel the two step movement
		if ((self_board | enemy_board) & (1 << (pawn_position + 8))) != 0:
			pawn_mask = 0
		
		# attackMask preset the pawn position at 1
		if pawn_position == 0:
			attack_mask >>= 1
		else:
			attack_mask <<= pawn_position - 1
	
	if pawn_position % 8 > 6:
		attack_mask &= ~0x303030303030303
	
	if pawn_position % 8 < 1:
		attack_mask &= ~0x4040404040404040
	
	attack_mask &= enemy_board
	pawn_mask ^= pawn_mask & (self_board | enemy_board)
	pawn_mask |= attack_mask
	
	return pawn_mask
