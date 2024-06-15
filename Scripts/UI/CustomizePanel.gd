extends Panel

func _ready():
	EventManager.connect("CustomizeClick", Callable(self,"OnCustomizeClick"))

func OnCustomizeClick():
	visible = true

func _on_close_button_button_up():
	visible = false
