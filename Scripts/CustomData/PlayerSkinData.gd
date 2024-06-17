extends Resource

class_name PlayerSkinData

@export var PlayerSkin : Texture2D
@export var PlayerSkinName = "null"
@export var UnlockID = ""

func IsOwned():
	var data = GameData.GetData("SKIN-" + UnlockID)
	if data:
		return true
	else:
		return false

func GetSkin():
	return PlayerSkin

func GetSkinName():
	return PlayerSkinName
