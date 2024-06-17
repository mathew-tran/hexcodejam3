extends Button

var TimesPressed = 0
var MaxAmountPress = 3

func _ready():
	$Label.text = ""

func _on_button_up():
	if $Timer.time_left == 0.0:
		$Timer.start()


	TimesPressed += 1
	if TimesPressed >= MaxAmountPress:
		GameData.ClearGame()

	var timesToPress = MaxAmountPress - TimesPressed
	$Label.text = "Press (" + str(timesToPress) + ") more times"

func _on_timer_timeout():
	TimesPressed = 0
