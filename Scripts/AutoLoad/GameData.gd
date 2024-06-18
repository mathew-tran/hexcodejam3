extends Node

signal Save
signal Load

var Data = {}

var SaveFilePath = "user://game.save"

func FirstTimeSave():
	(load("res://Data/Levelling/0.tres") as LevelupData).GiveReward()
	SaveGame()

func _ready():
	await get_tree().process_frame
	LoadGame()

func SaveGame():
	Save.emit()

	var saveFile = FileAccess.open(SaveFilePath, FileAccess.WRITE)
	saveFile.store_line(JSON.stringify(Data))
	saveFile.close()

func LoadGame():
	if FileAccess.file_exists(SaveFilePath):
		var saveFile = FileAccess.open(SaveFilePath, FileAccess.READ)
		while saveFile.get_position() < saveFile.get_length():
			var jsonString = saveFile.get_line()
			Data = JSON.parse_string(jsonString)
		saveFile.close()

	if Data.is_empty():
		FirstTimeSave()

	Load.emit()
	EventManager.Initialize()

func ClearGame():
	Data = {}
	var saveFile = FileAccess.open(SaveFilePath, FileAccess.WRITE)
	saveFile.store_line(JSON.stringify(Data))
	saveFile.close()
	EventManager.OnLoad()
	LoadGame()
	get_tree().paused = false
	get_tree().reload_current_scene()


func GetData(key):
	if Data.has(key):
		return Data[key]
	return null

func SaveData(key, value):
	Data[key] = value


func HasLoaded():
	return Data.is_empty() == false
