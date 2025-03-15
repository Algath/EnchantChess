extends Control


func _on_check_button_toggled(toggled_on: bool) -> void:
	if (toggled_on) : #host
		$"VBoxContainer/IP address".visible = false
		$VBoxContainer/CheckButton.text = "Host"
		pass
	else :
		$"VBoxContainer/IP address".visible = true
		$VBoxContainer/CheckButton.text = "Join"
		pass


func _on_enter_pressed() -> void:
	assert($VBoxContainer/Port != null)
	if($VBoxContainer/CheckButton.toggled):
		assert($"VBoxContainer/IP address" != null)
	
	get_tree().change_scene_to_file("res://gui.tscn")
