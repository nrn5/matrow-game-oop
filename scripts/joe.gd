extends CharacterBody3D

# onready global (script only)
@onready var healthBar = $bars/health
@onready var lanternBar = $bars/LanternHp
@onready var timer = $Timer
@onready var health = 100
@onready var lanternHP = 100
@onready var timerWait = 1

# wip - work on enemy signal health deplete
signal health_decrease(amountDmg)

# vars
var hitbox
var hitLight
var attackOn = false
var character
var characterMesh
var characterCol
var angleAcc = 10
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# on every frame
func _process(_delta):
	timer.wait_time = timerWait # Timer will count down from 5 seconds
	
# on ready local
func _ready():
	timer.start()
	healthBar.init_health(health)
	lanternBar.init_lanternHealth(lanternHP)
	# vars
	hitbox = $hitbox/joeAtkArea
	hitLight = $hitbox/joeAtkArea/joeAttack
	character = $"."
	characterMesh = $body
	characterCol = $bodyCol

# on setting health called update joe health
func _set_health(_value):
	#super._set_health(value)
	if health <= 0:
		charDeath()
	if health > 0:
		healthBar.health = health
	
# on set lantern health called update lantern health	
func _set_lanternHealth(_value):
	if lanternHP > 0:
		lanternBar.lanternHealth = lanternHP

# on timeout - wip
func _on_timer_timeout():
	lanternHP = lanternHP - 5
	health = health - 5
	_set_health(5)
	_set_lanternHealth(5)
	print(lanternHP)
	print(health)
	
# no joe dies call
func charDeath():
	pass

# movement 
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# rotation smoothed using lerp
		characterMesh.rotation.y = lerp_angle(characterMesh.rotation.y, atan2(-velocity.x, - velocity.z), delta * angleAcc)
		characterCol.rotation.y = lerp_angle(characterCol.rotation.y, atan2(-velocity.x, - velocity.z), delta * angleAcc)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	

	move_and_slide()
	
# on input
# fix bug wher atk stays on if held after depleted
func _input(event):
	if lanternHP > 0:
		if event.is_action_pressed("q"):
			print("***ATTACK***")
			hitbox.scale += Vector3(4.5, 4.5, 4.5)
			hitLight.light_energy = 15
			timer.start()
		if event.is_action_released("q"):
			print("***ATTACK RELEASE***")
			hitbox.scale -= Vector3(4.5, 4.5, 4.5)
			hitLight.light_energy = 0
			attackOn = false

# enemy enter joe hit box when attack
func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		print("*****ENEMY ENTER ATTACK HITBOX*****")
