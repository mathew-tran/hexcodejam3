extends RewardData

class_name PlayerSkinData

@export var PlayerSkin : Texture2D
@export var PlayerSkinName = "null"

func GetUnlockID():
	return ("SKIN-" + UnlockID)

func GetSkin():
	return PlayerSkin

func GetSkinName():
	return PlayerSkinName
