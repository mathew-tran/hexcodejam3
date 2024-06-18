extends Resource

class_name LevelupData

enum UNLOCKTYPE {
	MOD,
	SKIN
}

@export var AmountToLevel = 100
@export var UnlockReward : RewardData

func GiveReward():
	if is_instance_valid(UnlockReward):
		GameData.SaveData(UnlockReward.GetUnlockID(), true)

func GetAmountToLevel():
	return AmountToLevel

