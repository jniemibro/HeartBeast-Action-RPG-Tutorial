extends KinematicBody2D

export var speed = 100
const acceleration = 500
const friction = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	# match default blend pos for all anim states on start
	animationTree.set("parameters/Idle/blend_position", Vector2.ZERO)
	animationTree.set("parameters/Run/blend_position", Vector2.ZERO)
	animationTree.set("parameters/Attack/blend_position", Vector2.ZERO)

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
	# move_and_slide uses delta automatically
	velocity = move_and_slide(velocity)
	
func move_state(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# move_and_slide uses delta automatically
	#velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	# smoothly slow down
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	#velocity = Vector2.ZERO
	
	animationState.travel("Attack")
	# alternative to end state?
	#if animationState.get_current_node() != "Attack":
	#	state = MOVE

# called from animations
func attack_anim_finished():
	state = MOVE
