extends Button


func _on_button_up():
	EventManager.OptionPressed.emit()
