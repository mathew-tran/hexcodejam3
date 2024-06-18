extends Panel


func _ready():
	EventManager.connect("CustomizeClick", Callable(self,"OnCustomizeClick"))

func OnCustomizeClick():
	visible = true

func _on_close_button_button_up():
	visible = false


func _on_visibility_changed():
	if is_instance_valid(get_tree()):
		get_tree().paused = visible
		if visible:
			UpdateSkinButtons()

func UpdateSkinButtons():
	for button in $GridContainer.get_children():
		button.Update()
