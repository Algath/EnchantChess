extends Control



func _on_launch_lan_pressed() -> void:
	get_tree().change_scene_to_file("res://lan_menu.tscn")
	pass # Replace with function body.


func _on_launch_local_pressed() -> void:
	get_tree().change_scene_to_file("res://gui.tscn")


func _on_launch_bot_pressed() -> void:
	pass # Replace with function body.
