extends Node

signal AddTarget(target)
signal ClearTarget
signal AddDropArea(node)
signal ClearDropArea(node)
signal Initialized
signal ChangePlayerSkin(texture)
signal CustomizeClick
signal MoneyUpdate
signal PlayerConnect
signal PlayerDisconnect
signal OptionPressed
signal PlayerInitialized

var RewardAmount = 0
var Money = 0
var Level = 0
var TargetRef
var PlayerRef
var DropArea
var DestinationRef

var bIsInitialized = false

var SpawnPoints = []

func _ready():
	GameData.connect("Load", Callable(self,"OnLoad"))
	GameData.connect("Save", Callable(self,"OnSave"))

func Initialize():
	bIsInitialized = false
	MoneyUpdate.emit()


	if GameData.HasLoaded():
		OnLoad()

	connect("AddTarget", Callable(self, "OnAddTarget"))
	connect("ClearTarget", Callable(self, "OnClearTarget"))
	connect("AddDropArea", Callable(self, "OnAddDropArea"))
	connect("ClearDropArea", Callable(self, "OnClearDropArea"))

	if is_instance_valid(PlayerRef) == false:
		await PlayerInitialized
	bIsInitialized = true
	Initialized.emit()



func OnLoad():
	var data = GameData.GetData("Money")
	if data == null:
		Money = 0
	else:
		Money = data

	data = GameData.GetData("Level")
	if data == null:
		Level = 0
	else:
		Level = data

	MoneyUpdate.emit()

func OnSave():
	GameData.SaveData("Money", Money)
	GameData.SaveData("Level", Level)

func RegisterPoint(point):
	SpawnPoints.append(point)

func OnAddTarget(target):
	TargetRef = target

func OnClearTarget():
	TargetRef = null

func OnAddDropArea(node):
	DropArea = node

func OnClearDropArea():
	DropArea = null

func HasTarget():
	return is_instance_valid(TargetRef)

func GetTarget():
	return TargetRef

func GetPlayer():
	return PlayerRef

func GetDropArea():
	return DropArea

func UpdateDestination(node):
	DestinationRef = node

func GetDestination():
	return DestinationRef

func ClearDestination():
	DestinationRef = null

func GetTwoRandomPoints():
	SpawnPoints.shuffle()
	var points = []
	var index = 1
	while(SpawnPoints[index].distance_to(GetPlayer().global_position) < 600):
		index += 1
	points.append(SpawnPoints[index])
	points.append(SpawnPoints[0])
	return points

func GetItemsGroup():
	return get_tree().get_nodes_in_group("Items")[0]

func MakeJob():
	if is_instance_valid(GetTarget()) and is_instance_valid(GetPlayer()):
		return
	var points = GetTwoRandomPoints()
	var box = load(GetBoxClass()).instantiate()
	box.global_position = points[0]
	GetItemsGroup().add_child(box)

	var area = load(GetAreaClass()).instantiate()
	area.global_position = points[1]
	GetItemsGroup().add_child(area)

	var massModifier = round(box.mass * 50)
	RewardAmount = massModifier + 10 + randi() % 5 + roundi(points[0].distance_to(points[1]) / 500)
	FindBox()

	EventManager.GetPlayer().DisconnectObject()

func AddMoney(amount):
	Money += amount
	if Money > 999999:
		Money = 999999
	MoneyUpdate.emit()

func CanAfford(amount):
	return Money >= amount

func TakeMoney(amount):
	Money -= amount
	MoneyUpdate.emit()

func IncreaseLevel():
	Level += 1
	await get_tree().process_frame
	GameData.SaveGame()

func GiveReward():
	var text = load("res://Prefabs/UI/PopupText.tscn").instantiate()
	text.global_position = GetPlayer().global_position
	GetItemsGroup().add_child(text)
	text.Setup(RewardAmount)

	AddMoney(RewardAmount)
	RewardAmount = 0

	AttemptRandomBonus()
	GameData.SaveGame()

func AttemptRandomBonus():
	var result = randi() % 100
	if result >= 85:
		await get_tree().create_timer(.5).timeout
		var reward = 25 + (randi() % 5 ) * 5
		AddMoney(reward)
		var text = load("res://Prefabs/UI/PopupText.tscn").instantiate()
		text.global_position = GetPlayer().global_position
		GetItemsGroup().add_child(text)
		text.Setup(reward)



func GetBoxClass():
	return "res://Prefabs/Interactables/Box.tscn"

func GetAreaClass():
	return "res://Prefabs/Interactables/DropArea.tscn"

func FindBox():
	EventManager.AddTarget.emit(get_tree().get_nodes_in_group("Box")[0])
	EventManager.UpdateDestination(get_tree().get_nodes_in_group("Box")[0])

func FindArea():
	EventManager.AddDropArea.emit(get_tree().get_nodes_in_group("DropArea")[0])
	EventManager.UpdateDestination(get_tree().get_nodes_in_group("DropArea")[0])

