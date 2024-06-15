extends RigidBody2D

class_name DeliveryBox
@onready var PickedUpParticle = $CPUParticles2D2

func PickedUp():
	PickedUpParticle.emitting = false

func DropOff():
	PickedUpParticle.emitting = true
