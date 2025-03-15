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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assets.append("res://image/pieces/white_bishop.png")
	assets.append("res://image/pieces/white_king.png")
	assets.append("res://image/pieces/white_knight.png")
	assets.append("res://image/pieces/white_pawn.png")
	assets.append("res://image/pieces/white_queen.png")
	assets.append("res://image/pieces/white_rook.png")
	assets.append("res://image/pieces/black_bishop.png")
	assets.append("res://image/pieces/black_king.png")
	assets.append("res://image/pieces/black_knight.png")
	assets.append("res://image/pieces/black_pawn.png") 
	assets.append("res://image/pieces/black_queen.png")
	assets.append("res://image/pieces/black_rook.png")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
