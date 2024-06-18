extends RigidBody2D

class_name Player

var LastPositionTouched = Vector2.ZERO
var SteerDirection = Vector2.ZERO
var UpThrust = 250000
var SideThrust = 50000


@onready var Sprite = $Sprite2D
@onready var CollisionShape = $CollisionShape2D
@onready var PinJoint = $Connector/PinJoint2D
@onready var Line = $Line2D

var bIsPressed = false
var LastRotation = Vector2.ZERO
var RotationProgress = 0

func _ready():
	$Camera2D.set_physics_process(true)

	EventManager.PlayerRef = self
	EventManager.PlayerInitialized.emit()

	EventManager.connect("ChangePlayerSkin", Callable(self, "OnChangePlayerSkin"))

	if EventManager.LastSkin != "":
		OnChangePlayerSkin(load(EventManager.LastSkin))


func OnChangePlayerSkin(newTexture):
	Sprite.texture = newTexture
	GameData.SaveData("LastSkin", newTexture.resource_path)

func OrientUpright(_delta):
	var targetRotation = 0.0
	if LastPositionTouched.x > global_position.x:
		targetRotation = deg_to_rad(5)
	elif LastPositionTouched.x < global_position.x:
		targetRotation = deg_to_rad(-5)

	if abs(linear_velocity.x) > 1:
		targetRotation *= abs(linear_velocity.x/80)
	var rotationDifference = targetRotation - rotation
	rotationDifference = wrapf(rotationDifference, -PI, PI)
	angular_velocity = rotationDifference * 10

func _process(delta):
	if IsConnected():
		var obj = get_node_or_null(PinJoint.node_b)
		if is_instance_valid(obj):
			Line.points[1] = to_local(obj.global_position)
		else:
			DisconnectObject()


	if Input.is_action_pressed("mouse_click"):
		bIsPressed = true
		OrientUpright(delta)

		var verticalSpeed = linear_velocity.y
		if verticalSpeed > -1500 or verticalSpeed > 0 :
			apply_force(Vector2.UP * UpThrust * delta, Vector2.ZERO)
		LastPositionTouched = get_global_mouse_position()
		if IsClosetoXPosition():
			ResetSteer()
		elif LastPositionTouched.x < global_position.x:
			SteerDirection = Vector2.LEFT
		elif LastPositionTouched.x > global_position.x:
			SteerDirection = Vector2.RIGHT
		else:
			ResetSteer()
	else:
		bIsPressed = false
		LastPositionTouched.x = global_position.x
		LastRotation = rotation_degrees
		RotationProgress = 0

func _input(event):
	if event.is_action_pressed("right_click"):
		DisconnectObject()

func DisconnectObject():
	var box = get_node_or_null(PinJoint.node_b) as DeliveryBox
	if is_instance_valid(box):
		box.DropOff()
	PinJoint.node_b = NodePath("")
	Line.points[1] = Line.points[0]
	EventManager.PlayerDisconnect.emit()

func ResetSteer():
	SteerDirection = Vector2.ZERO

func IsMoving():
	return linear_velocity.length() > 5

func IsClosetoXPosition():
	return abs(global_position.x - LastPositionTouched.x) < 100

func _physics_process(delta):
	var horizontalSpeed = abs(linear_velocity.x)
	if horizontalSpeed < 1000:
		apply_force(SteerDirection * SideThrust * delta, Vector2.ZERO)

	if IsClosetoXPosition():
		ResetSteer()
	if linear_velocity.y == 0 and linear_velocity.x == 0:
		ResetSteer()

func IsConnected():
	return PinJoint.node_b != NodePath("")

func _on_connect_joint_body_entered(body):
	if IsConnected():
		return

	if body.is_in_group("Box"):
		var box = body as DeliveryBox
		if PinJoint.node_b != box.get_path():
			var strengthUsed = lerp(0, 1, (box.mass/1))
			$Line2D.default_color = lerp(Color("ffffff"), Color("ff000c"), strengthUsed)
			PinJoint.node_b = box.get_path()
			box.PickedUp()
			EventManager.PlayerConnect.emit()

