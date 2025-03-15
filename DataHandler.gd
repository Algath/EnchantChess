extends Node

var assets := []
enum PieceNames {white_bishop, white_king, white_knight, white_pawn, white_queen, white_rook, black_bishop, black_king, balck_knight, black_pawn, black_queen, black_rook}
var fen_dict := {
	"b" = PieceNames.black_bishop, "k" = PieceNames.black_king,
	"n" = PieceNames.balck_knight, "p" = PieceNames.black_pawn,
	"q" = PieceNames.black_queen, "r" = PieceNames.black_rook,
	"B" = PieceNames.white_bishop, "K" = PieceNames.white_king,
	"N" = PieceNames.white_knight, "P" = PieceNames.white_pawn,
	"Q" = PieceNames.white_queen, "R" = PieceNames.white_rook,
}

enum slot_states{NONE, FREE}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assets.append("res://image/pieces/white_bishop.png") #0
	assets.append("res://image/pieces/white_king.png") #1
	assets.append("res://image/pieces/white_knight.png") #2
	assets.append("res://image/pieces/white_pawn.png") #3
	assets.append("res://image/pieces/white_queen.png") #4
	assets.append("res://image/pieces/white_rook.png") #5
	assets.append("res://image/pieces/black_bishop.png") #6
	assets.append("res://image/pieces/black_king.png")#7
	assets.append("res://image/pieces/black_knight.png") #8
	assets.append("res://image/pieces/black_pawn.png") #9
	assets.append("res://image/pieces/black_queen.png") #10
	assets.append("res://image/pieces/black_rook.png")#11
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
