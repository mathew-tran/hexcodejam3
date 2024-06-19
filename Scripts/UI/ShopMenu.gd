extends Panel

@onready var CurrentLevel = $VBoxContainer/HBoxContainer/CurrentLevel
@onready var ConvertArrow = $VBoxContainer/HBoxContainer/ConvertArrow
@onready var NextLevel = $VBoxContainer/HBoxContainer/NextLevel

@onready var PriceContainer = $VBoxContainer/VBoxContainer
@onready var PriceText = $VBoxContainer/VBoxContainer/PriceText
@onready var PurchaseButton =  $VBoxContainer/Button

var NextLevelItem = null

var DirectoryPath = "res://Data/Levelling"

var MaxLevel = 0
func Initialize():
	if DirAccess.dir_exists_absolute(DirectoryPath) == false:
		return
	var Levels = []
	var dir = DirAccess.open(DirectoryPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() == false:
			print(file_name)
			file_name = file_name.trim_suffix(".remap")
			if file_name.ends_with(".tres"):
				Levels.append(file_name)
			file_name = dir.get_next()
			print(file_name + " NEXT")
	dir.list_dir_end()
	MaxLevel = len(Levels)
	print(MaxLevel)


func SetLevelData():
	var nextLevelPath = DirectoryPath + "/" + str(EventManager.Level +1) + ".tres"
	if FileAccess.file_exists(nextLevelPath) == false:
		nextLevelPath += ".remap"
	if FileAccess.file_exists(nextLevelPath):
		NextLevelItem = load(nextLevelPath) as LevelupData


func _ready():
	EventManager.connect("ShopPressed", Callable(self, "OnShopPressed"))
	Initialize()


func OnShopPressed():
	visible = true

func _on_close_button_button_up():
	visible = false


func _on_visibility_changed():

	if is_instance_valid(PriceText):

		get_tree().paused = visible
		if visible:
			UpdatePage()

func UpdatePage():
	CurrentLevel.SetLevel(EventManager.Level)
	if EventManager.Level >= MaxLevel -1:
		ConvertArrow.visible = false
		NextLevel.visible = false
		PurchaseButton.visible = false
		PriceContainer.visible = false
		return
	SetLevelData()
	if NextLevelItem == null:
		return
	PriceText.text = str(EventManager.Money) + "/" + str(NextLevelItem.GetAmountToLevel())
	NextLevel.SetLevel(EventManager.Level + 1)
	PurchaseButton.disabled = EventManager.CanAfford(NextLevelItem.GetAmountToLevel()) == false


func _on_button_button_up():
	EventManager.IncreaseLevel()
	NextLevelItem.GiveReward()
	$RewardPanel.Show(NextLevelItem.UnlockReward)
	EventManager.TakeMoney(NextLevelItem.GetAmountToLevel())
	UpdatePage()


func _on_accept_dialog_confirmed():
	$CloseButton.grab_focus()
