extends Button


@export var DroneTexture : Texture

var bIsOwned = true

func _ready():
	Setup(DroneTexture)

func Setup(droneTexture):
	#Logic to see if it's owned
	DroneTexture = droneTexture
	$TextureRect.texture = droneTexture
	if bIsOwned == true:
		$TextureRect.modulate = Color.WHITE



func _on_button_up():
	EventManager.ChangePlayerSkin.emit(DroneTexture)
