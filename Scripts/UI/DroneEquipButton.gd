extends Button


@export var DroneData : PlayerSkinData

func _ready():
	#Need to put this elsewhere.. basically upper level should populate, and at that time the data should have been loaded.
	await EventManager.Initialized
	Setup(DroneData)

func Setup(droneData):
	DroneData = droneData
	$TextureRect.texture = DroneData.GetSkin()
	if DroneData.IsOwned():
		$TextureRect.modulate = Color.WHITE
		$Label.text = DroneData.GetSkinName()
	else:
		$TextureRect.modulate = Color.BLACK
		$Label.text = "???"



func _on_button_up():
	if DroneData.IsOwned():
		EventManager.ChangePlayerSkin.emit(DroneData.GetSkin())
