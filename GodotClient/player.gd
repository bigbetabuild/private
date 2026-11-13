extends CharacterBody3D

@export var move_speed: float = 7.0
@export var jump_velocity: float = 6.5
@export var mouse_sensitivity: float = 0.0025

var camera_pivot: Node3D
var camera: Camera3D
var gravity: float = float(ProjectSettings.get_setting("physics/3d/default_gravity"))

func _ready() -> void:
	_ensure_input_actions()
	_build_character()

func _ensure_input_actions() -> void:
	_add_key_action("move_forward", KEY_W)
	_add_key_action("move_back", KEY_S)
	_add_key_action("move_left", KEY_A)
	_add_key_action("move_right", KEY_D)
	_add_key_action("jump", KEY_SPACE)

func _add_key_action(action_name: StringName, keycode: Key) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	var event := InputEventKey.new()
	event.physical_keycode = keycode
	InputMap.action_add_event(action_name, event)

func _build_character() -> void:
	var collision := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.8
	collision.shape = capsule
	collision.position.y = 0.9
	add_child(collision)

	var body_mesh := MeshInstance3D.new()
	var capsule_mesh := CapsuleMesh.new()
	capsule_mesh.radius = 0.45
	capsule_mesh.height = 1.8
	body_mesh.mesh = capsule_mesh
	body_mesh.position.y = 0.9
	var body_material := StandardMaterial3D.new()
	body_material.albedo_color = Color("3d6fc4")
	body_mesh.material_override = body_material
	add_child(body_mesh)

	camera_pivot = Node3D.new()
	camera_pivot.name = "CameraPivot"
	camera_pivot.position.y = 1.35
	add_child(camera_pivot)

	camera = Camera3D.new()
	camera.position = Vector3(0.0, 0.45, 4.5)
	camera.rotation.x = deg_to_rad(-10.0)
	camera.current = true
	camera_pivot.add_child(camera)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_direction := (global_transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	velocity.x = movement_direction.x * move_speed
	velocity.z = movement_direction.z * move_speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, deg_to_rad(-55.0), deg_to_rad(35.0))
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
