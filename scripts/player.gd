extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var SPRINT_MUL = 1.3

var is_paused : bool = false :
	set(value):
		is_paused = value
		if(value):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
@onready var camera = $Camera
var mouse_sens = 0.3
var camera_anglev = 0
const CAMERA_MAXV = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	#Handle jump
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#Handle pause
	elif event.is_action_pressed("pause"):
		is_paused = !is_paused
		
	#Handle camera
	elif !is_paused and event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		var changev = -event.relative.y * mouse_sens
		if camera_anglev + changev > -CAMERA_MAXV and camera_anglev+changev < CAMERA_MAXV:
			camera_anglev += changev
			camera.rotate_x(deg_to_rad(changev))
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if !is_paused:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var effective_speed = SPRINT_MUL * SPEED if Input.is_action_pressed("sprint") else SPEED
		if direction:
			velocity.x = direction.x * effective_speed
			velocity.z = direction.z * effective_speed
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
