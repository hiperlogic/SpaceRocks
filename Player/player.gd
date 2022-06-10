extends RigidBody2D

enum States {INIT, ALIVE, INVULNERABLE, DEAD}
var state = null

export (int) var engine_power
export (int) var spin_power

var thrust = Vector2()
var rotation_dir = 0

var screensize = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(States.ALIVE)
	screensize = get_viewport().get_visible_rect().size

func change_state(new_state):
	### TODO: Should check if the current to new state transition is ok
	### Set up the new state properties
	match new_state:
		States.INIT:
			$CollisionShape2D.disabled = true
		States.ALIVE:
			$CollisionShape2D.disabled = false
		States.INVULNERABLE:
			$CollisionShape2D.disabled = true
		States.DEAD:
			$CollisionShape2D.disabled = true
	state = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
#	pass

func get_input():
	thrust = Vector2()
	if state in [States.DEAD, States.INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_power, 0)
	rotation_dir=0
	if Input.is_action_pressed("rotate_right"):
		rotation_dir+=.1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -=.1
		
func _physics_process(delta):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power * rotation_dir)
	pass
	
func _integrate_forces(physics_state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power*rotation_dir)
	var xform = physics_state.get_transform()
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	if xform.origin.x<0:
		xform.origin.x = screensize.x
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screensize.y
	physics_state.set_transform(xform)

