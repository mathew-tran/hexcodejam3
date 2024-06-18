extends Resource

class_name RewardData
@export var UnlockID = ""

func IsOwned():
	var data = GameData.GetData(GetUnlockID())
	if data:
		return true
	else:
		return false

func GetUnlockID():
	return ("SKIN-" + UnlockID)
