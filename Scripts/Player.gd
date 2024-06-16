extends RigidBody2D

class_name Player

var LastPositionTouched = Vector2.ZERO
var SteerDirection = Vector2.ZERO
var UpThrust = 190000
var SideThrust = 30000


@onready var Sprite = $Sprite2D
@onready var CollisionShape = $CollisionShape2D
@onready var PinJoint = $Connector/PinJoint2D
@onready var Line = $Line2D

var bIsPressed = false

func _ready():
	$Camera2D.set_physics_process(true)

	EventManager.connect("ChangePlayerSkin", Callable(self, "OnChangePlayerSkin"))
	if EventManager.bIsInitialized == false:
		await EventManager.Initialized

	EventManager.MakeJob()

func OnChangePlayerSkin(newTexture):
	Sprite.texture = newTexture

func _process(delta):
	if IsConnected():
		Line.points[1] = to_local(get_node(PinJoint.node_b).global_position)

	if Input.is_action_pressed("mouse_click"):
		bIsPressed = true
		apply_force(Vector2.UP * UpThrust * delta, Vector2.ZERO)
		LastPositionTouched = get_global_mouse_position()
		if IsClosetoXPosition():
			ResetSteer()
			return

		if LastPositionTouched.x < global_position.x:
			SteerDirection = Vector2.LEFT
		elif LastPositionTouched.x > global_position.x:
			SteerDirection = Vector2.RIGHT
		else:
			ResetSteer()
	else:
		bIsPressed = false

func _input(event):
	if event.is_action_pressed("right_click"):
		DisconnectObject()

func DisconnectObject():
	if PinJoint.node_b != NodePath(""):
		var box = get_node(PinJoint.node_b) as DeliveryBox
		if is_instance_valid(box):
			box.DropOff()
		PinJoint.node_b = NodePath("")
	Line.points[1] = Vector2.ZERO

func ResetSteer():
	SteerDirection = Vector2.ZERO

func IsMoving():
	return linear_velocity.length() > 5

func IsClosetoXPosition():
	return abs(global_position.x - LastPositionTouched.x) < 100

func _physics_process(delta):
	apply_force(SteerDirection * SideThrust * delta, Vector2.ZERO)
	if IsClosetoXPosition():
		ResetSteer()
	if linear_velocity.y == 0 and linear_velocity.x == 0:
		ResetSteer()

	var targetRotation = 0
	if SteerDirection.x != 0:
		if SteerDirection.x > 0:
			targetRotation = 15
		else:
			targetRotation = -15

	Sprite.rotation_degrees = targetRotation
	CollisionShape.rotation_degrees = Sprite.rotation_degrees






func IsConnected():
	return PinJoint.node_b != NodePath("")

func _on_connect_joint_body_entered(body):
	if IsConnected():
		return

	if body.is_in_group("Box"):
		var box = body as DeliveryBox
		if PinJoint.node_b != box.get_path():
			PinJoint.node_b = box.get_path()
			box.PickedUp()
