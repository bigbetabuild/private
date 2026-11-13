extends Node3D

const PLAYER_SCRIPT = preload("res://player.gd")

var world_root: Node3D
var ui_layer: CanvasLayer
var menu_panel: PanelContainer
var status_label: Label

func _ready() -> void:
	_build_world()
	_build_ui()

func _build_world() -> void:
	world_root = Node3D.new()
	world_root.name = "World"
	add_child(world_root)

	var environment := WorldEnvironment.new()
	var environment_data := Environment.new()
	environment_data.background_mode = Environment.BG_SKY
	environment_data.sky = Sky.new()
	environment.environment = environment_data
	world_root.add_child(environment)

	var sunlight := DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-55.0, -30.0, 0.0)
	sunlight.light_energy = 1.1
	world_root.add_child(sunlight)

	_add_box(Vector3(0.0, -0.5, 0.0), Vector3(48.0, 1.0, 48.0), Color("5d9b45"), true)
	_add_box(Vector3(0.0, 0.1, -8.0), Vector3(8.0, 0.2, 8.0), Color("9a7652"), false)
	_add_box(Vector3(-5.0, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("d84d3f"), true)
	_add_box(Vector3(-3.5, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("e8c547"), true)
	_add_box(Vector3(3.5, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("407ac2"), true)
	_add_box(Vector3(5.0, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("eeeeee"), true)

	# A few low-poly trees make the starter map feel like a small classic sandbox.
	for tree_position in [Vector3(-10, 0, -4), Vector3(10, 0, -5), Vector3(-9, 0, 8), Vector3(9, 0, 9)]:
		_add_box(tree_position + Vector3(0, 1.0, 0), Vector3(0.8, 2.0, 0.8), Color("76502e"), true)
		_add_box(tree_position + Vector3(0, 3.0, 0), Vector3(3.0, 2.5, 3.0), Color("3f883d"), true)

func _add_box(position: Vector3, size: Vector3, color: Color, solid: bool) -> void:
	var body: StaticBody3D
	if solid:
		body = StaticBody3D.new()
		body.position = position
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.add_child(collision)
		world_root.add_child(body)
	else:
		body = StaticBody3D.new()
		body.position = position
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.add_child(collision)
		world_root.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh_instance.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	mesh_instance.material_override = material
	body.add_child(mesh_instance)

func _build_ui() -> void:
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)

	var screen := Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_layer.add_child(screen)

	menu_panel = PanelContainer.new()
	menu_panel.set_anchors_preset(Control.PRESET_CENTER)
	menu_panel.position = Vector2(-210.0, -160.0)
	menu_panel.custom_minimum_size = Vector2(420.0, 320.0)
	screen.add_child(menu_panel)

	var menu := VBoxContainer.new()
	menu.add_theme_constant_override("separation", 14)
	menu_panel.add_child(menu)

	var title := Label.new()
	title.text = "NOUNBLOX"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	menu.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "A classic block-building revival — Godot prototype"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu.add_child(subtitle)

	var play_button := Button.new()
	play_button.text = "Play sandbox"
	play_button.custom_minimum_size = Vector2(0, 48)
	play_button.pressed.connect(_start_game)
	menu.add_child(play_button)

	var controls := Label.new()
	controls.text = "WASD: move    Space: jump\nMouse: look    Esc: release / capture mouse"
	controls.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	controls.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu.add_child(controls)

	status_label = Label.new()
	status_label.text = "NOUNBLOX  •  GODOT CLIENT PROTOTYPE"
	status_label.position = Vector2(18.0, 14.0)
	screen.add_child(status_label)

func _start_game() -> void:
	menu_panel.hide()
	var player := CharacterBody3D.new()
	player.name = "Player"
	player.set_script(PLAYER_SCRIPT)
	player.position = Vector3(0.0, 1.5, 4.0)
	world_root.add_child(player)
	status_label.text = "WASD Move  •  Space Jump  •  Esc Mouse"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
