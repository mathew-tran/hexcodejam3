extends Node

signal AddTarget(target)
signal ClearTarget
signal AddDropArea(node)
signal ClearDropArea(node)
signal Initialized

var TargetRef
var PlayerRef
var DropArea
var DestinationRef

var bIsInitialized = false

func _ready():
	connect("AddTarget", Callable(self, "OnAddTarget"))
	connect("ClearTarget", Callable(self, "OnClearTarget"))
	connect("AddDropArea", Callable(self, "OnAddDropArea"))
	connect("ClearDropArea", Callable(self, "OnClearDropArea"))

	await get_tree().create_timer(1).timeout
	PlayerRef = get_tree().get_nodes_in_group("Player")[0]
	bIsInitialized = true
	Initialized.emit()

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

func FindBox():
	EventManager.AddTarget.emit(get_tree().get_nodes_in_group("Box")[0])
	EventManager.UpdateDestination(get_tree().get_nodes_in_group("Box")[0])

func FindArea():
	EventManager.AddDropArea.emit(get_tree().get_nodes_in_group("DropArea")[0])
	EventManager.UpdateDestination(get_tree().get_nodes_in_group("DropArea")[0])

