extends RigidBody2D

signal shoot
signal lives_changed

var lives = 0 setget set_lives

enum States {INIT, ALIVE, INVULNERABLE, DEAD}
var state = null

export (int) var engine_power
export (int) var spin_power

export (PackedScene) var Bullet
export (float) var fire_rate

var can_shoot = true

var thrust = Vector2()
var rotation_dir = 0

var screensize = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(States.ALIVE)
	screensize = get_viewport().get_visible_rect().size
	$GunTimer.wait_time = fire_rate

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
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		
func shoot():
	if state == States.INVULNERABLE:
		return
	emit_signal("shoot", Bullet, $Muzzle.global_position, rotation)
	can_shoot = false
	$GunTimer.start()
		
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

func set_lives(value):
	lives = value
	emit_signal("lives_changed", lives)

func start():
	$Sprite.show()
	self.lives = 3
	change_state(States.ALIVE)
	
func _on_GunTimer_timeout():
	can_shoot = true
	pass # Replace with function body.
