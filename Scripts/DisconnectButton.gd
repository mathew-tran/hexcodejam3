extends Button


func _ready():
	visible = false
	EventManager.connect("PlayerConnect", Callable(self, "OnPlayerConnect"))
	EventManager.connect("PlayerDisconnect", Callable(self, "OnPlayerDisconnect"))

func OnPlayerConnect():
	visible = true
	grab_focus()

func OnPlayerDisconnect():
	visible = false

func _on_button_up():
	EventManager.GetPlayer().DisconnectObject()


