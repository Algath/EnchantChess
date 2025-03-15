extends Control

@onready var main = $"../Gui"

var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

func _on_launch_lan_pressed() -> void:
	get_tree().change_scene_to_file("res://lan_menu.tscn")
	pass # Replace with function body.


func _on_launch_bot_pressed() -> void:
	pass


func _on_launch_local_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		GameData.current_fen = fen
		GameData.should_parse_fen = true
		get_tree().change_scene_to_file("res://gui.tscn")
