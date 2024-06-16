extends RigidBody2D

class_name DeliveryBox
@onready var PickedUpParticle = $CPUParticles2D2

func _ready():

	EventManager.AddTarget.emit(self)

func Setup():
	$CollisionShape2D.disabled = false

func PickedUp():
	PickedUpParticle.emitting = false
	EventManager.FindArea()

func DropOff():
	PickedUpParticle.emitting = true
	EventManager.UpdateDestination(self)
