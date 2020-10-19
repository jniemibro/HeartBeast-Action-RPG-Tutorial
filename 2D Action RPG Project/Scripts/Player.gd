extends KinematicBody2D

export var speed = 100

const ROLL_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

const START_VECTOR = Vector2.DOWN

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = START_VECTOR

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	# match default blend pos for all anim states on start
	animationTree.set("parameters/Idle/blend_position", START_VECTOR)
	animationTree.set("parameters/Run/blend_position", START_VECTOR)
	animationTree.set("parameters/Attack/blend_position", START_VECTOR)
	animationTree.set("parameters/Roll/blend_position", START_VECTOR)

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	# move_and_slide uses delta automatically
	#velocity = move_and_slide(velocity)
	
func _physics_process(_delta):
	# move_and_slide uses delta automatically
	velocity = move_and_slide(velocity)
	
func move_state(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		roll_vector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Roll/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * speed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# move_and_slide uses delta automatically
	#velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		velocity = roll_vector * ROLL_SPEED
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	# smoothly slow down
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	#velocity = Vector2.ZERO
	
	animationState.travel("Attack")
	# alternative to end state?
	#if animationState.get_current_node() != "Attack":
	#	state = MOVE

func roll_state(delta):
	animationState.travel("Roll")

# called from animations
func attack_anim_finished():
	state = MOVE

func roll_anim_finished():
	velocity *= 0.8
	state = MOVE
