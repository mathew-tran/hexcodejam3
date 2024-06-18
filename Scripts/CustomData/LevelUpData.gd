extends Resource

class_name LevelupData

enum UNLOCKTYPE {
	MOD,
	SKIN
}

@export var AmountToLevel = 100
@export var UnlockID = "null"
@export var UnlockName = "null"
@export var UnlockTexture : Texture2D
@export var UnlockType : UNLOCKTYPE

func GiveReward():
	if UnlockID != "null":
		GameData.SaveData(GetUnlockName(), true)

func GetAmountToLevel():
	return AmountToLevel

func GetUnlockName():
	return UNLOCKTYPE.keys()[UnlockType] + "-" + UnlockID
