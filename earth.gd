extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _fixed_process(delta):
	move(Vector2(0.1,0.2))
	#pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
