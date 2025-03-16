extends Control

var fen = "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"

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
