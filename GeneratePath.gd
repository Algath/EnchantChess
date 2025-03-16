extends Node

func _ready():
	pass

func _process(delta):
	pass

func print_bitboard(board):
	for y in range(7, -1, -1):
		var line = ""
		for x in range(8):
			var pos = y * 8 + x
			line += "1 " if (board & (1 << pos)) != 0 else "0 "
		print(line)
	print("")

func rook_path(rook_position, self_board, occupied_board, is_black):
	var legal_moves = 0
	var direction = [1, -1, 8, -8]
	# Calculate moves to the right
	for dir in direction:
		var targetPos = rook_position + dir

		if (dir == 1 and rook_position % 8 == 7) :
			continue
		elif (dir == -1 and rook_position % 8 == 0):
			continue
		if (targetPos < 0 or targetPos >= 64):
			continue
			
		if (occupied_board & (1 << targetPos)) != 0:
			break
		legal_moves |= 1 << targetPos
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
	var king_mask = 0
	
	# Génération du masque standard du roi (toutes les cases adjacentes)
	var standard_king_mask = 460039
	var shift_amount = king_position - 9
	
	if shift_amount >= 0:
		standard_king_mask <<= shift_amount
	else:
		standard_king_mask >>= -shift_amount
	
	# Ajustements pour les bords de l'échiquier
	if king_position % 8 > 6:
		standard_king_mask &= ~0x303030303030303
	
	if king_position % 8 < 1:
		standard_king_mask &= ~0x4040404040404040
	
	# Le roi ne peut se déplacer QUE sur les cases occupées par ses propres pièces
	king_mask = standard_king_mask & self_board
	
	# On retire la position du roi lui-même (il ne peut pas rester sur place)
	king_mask &= ~(1 << king_position)
	
	return king_mask

func pawn_path(pawn_position, self_board, enemy_board, is_black):
	var pawn_mask = 0
	
	if is_black:
		# Pour les pions noirs, le déplacement est toujours d'une case vers le bas
		pawn_mask = 0x80000000000000  # Un seul bit pour avancer d'une case
		pawn_mask >>= 63 - pawn_position
	else:
		# Pour les pions blancs, le déplacement est toujours d'une case vers le haut
		pawn_mask = 0x100  # Un seul bit pour avancer d'une case
		pawn_mask <<= pawn_position
	
	# Vérifier si la case devant est occupée (par une pièce amie ou ennemie)
	# Si oui, annuler le mouvement
	pawn_mask ^= pawn_mask & (self_board | enemy_board)
	
	# On ne garde pas la partie attack_mask car les pions ne peuvent plus attaquer
	
	return pawn_mask
