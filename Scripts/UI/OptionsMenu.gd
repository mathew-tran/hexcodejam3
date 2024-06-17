extends Panel


func _ready():
	EventManager.connect("OptionPressed", Callable(self, "OnOptionPressed"))

func OnOptionPressed():
	visible = true

func _on_visibility_changed():
	if is_instance_valid(get_tree()):
		get_tree().paused = visible


func _on_resume_button_button_up():
	visible = false
