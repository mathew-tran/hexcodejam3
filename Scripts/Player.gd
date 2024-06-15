extends RigidBody2D

var LastPositionTouched = Vector2.ZERO
var SteerDirection = Vector2.ZERO
var UpThrust = 190000
var SideThrust = 30000


@onready var Sprite = $Sprite2D
@onready var CollisionShape = $CollisionShape2D
@onready var PinJoint = $Connector/PinJoint2D

@onready var MoveParticles = [
	$Particle1,
	$Partcle2
]

var bIsPressed = false

func _ready():
	$Camera2D.set_physics_process(true)
	pass

func _process(delta):
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
	PinJoint.node_b = NodePath("")

func ResetSteer():
	SteerDirection = Vector2.ZERO

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



func _on_timer_timeout():
	for particle in MoveParticles:
		particle.emitting = bIsPressed



func IsConnected():
	return PinJoint.node_b != NodePath("")

func _on_connect_joint_body_entered(body):
	if IsConnected():
		return

	print("joint connect attempt")
	if body.is_in_group("Box"):
		if PinJoint.node_b != body.get_path():
			PinJoint.node_b = body.get_path()
