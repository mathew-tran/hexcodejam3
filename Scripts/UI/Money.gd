extends Label


func _ready():
	EventManager.connect("MoneyUpdate", Callable(self, "OnMoneyUpdate"))
	OnMoneyUpdate()

func OnMoneyUpdate():
	text = str(EventManager.Money)
