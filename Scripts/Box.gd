extends RigidBody2D

class_name DeliveryBox
@onready var PickedUpParticle = $CPUParticles2D2

func _init():
	var result = randi() % 100
	if result < 50:
		mass = randf_range(.1, .3)
	elif result < 70:
		mass = randf_range(.4, .5)
	else:
		mass = randf_range(.6, .8)
func _ready():
	EventManager.AddTarget.emit(self)

func PickedUp():
	PickedUpParticle.emitting = false
	EventManager.FindArea()

func DropOff():
	PickedUpParticle.emitting = true
	EventManager.UpdateDestination(self)
