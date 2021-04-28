extends Node2D

onready var SPRITE = $SPRITE
onready var CAMERA = get_node("../CAMERA")
onready var ANIMATION_PLAYER = $ANIMATION_PLAYER
var CLICK : bool
var MOUSE_POS
const FOLLOW_SPEED = 12

func _physics_process(delta):
	MOUSE_POS = get_global_mouse_position()
	SPRITE.global_position = SPRITE.global_position.linear_interpolate(MOUSE_POS, delta * FOLLOW_SPEED)
	CAMERA.global_position = CAMERA.global_position.linear_interpolate((CAMERA.global_position + MOUSE_POS) * 0.2, delta * FOLLOW_SPEED)
	
	if Input.is_action_just_pressed("CLICK"):
		CLICK = true
	elif Input.is_action_just_released("CLICK"):
		CLICK = false
	
	if CLICK == true:
		ANIMATION_PLAYER.play("CLICK")
	else:
		ANIMATION_PLAYER.play("IDLE")
