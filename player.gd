extends KinematicBody

const MOVE_SPEED = 1.6
const JUMP_FORCE = 6
const GRAVITY = 0.5
const MAX_FALL_SPEED = 5

const H_LOOK_SENS = 1.0
const V_LOOK_SENS = 1.0

onready var anim = $AnimatedSprite3D
onready var walk_particles = $walk_particles
onready var jump_particles = preload("res://jump_particles.tscn")

var y_velo = 0
var anim_back = ""
var inertia = 10

func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_up"):
		move_vec.z += 1
		move_vec.x -= 1
		anim_back = "_back"
	if Input.is_action_pressed("move_down"):
		move_vec.z -= 1
		move_vec.x += 1
		anim_back = ""
	if Input.is_action_pressed("move_left"):
		move_vec.z += 1
		move_vec.x += 1
		anim.flip_h = true
		if Input.is_action_pressed("move_up"):
			anim.flip_h = false
			anim_back = "_back"
		if !Input.is_action_pressed("move_up"):
			anim_back = ""
	if Input.is_action_pressed("move_right"):
		move_vec.z -= 1
		move_vec.x -= 1
		anim.flip_h = false
		if Input.is_action_pressed("move_up"):
			anim.flip_h = true
			anim_back = "_back"
		if !Input.is_action_pressed("move_up"):
			anim_back = ""
	move_vec = move_vec.normalized()
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	move_and_slide(move_vec, Vector3(0, 1, 0), true, 4, 0.785398, false)
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("jump"):
		just_jumped = true
		y_velo = JUMP_FORCE
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	
	if just_jumped:
		anim.play(str("jump",anim_back))
		walk_particles.emitting = false
		var new_jump_particles = jump_particles.instance()
		add_child(new_jump_particles)
	elif grounded:
		if move_vec.x == 0 and move_vec.z == 0:
			anim.play(str("idle",anim_back))
			walk_particles.emitting = false
		else:
			anim.play(str("walk",anim_back))
			walk_particles.emitting = true
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(-collision.normal * inertia)
#		if collision.collider.name == "cylinder": 
		
