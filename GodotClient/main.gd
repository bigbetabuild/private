extends Node3D

const PLAYER_SCENE: PackedScene = preload("res://GodotClient/player.tscn")

var world_root: Node3D
var menu_panel: PanelContainer
var status_label: Label
var player: CharacterBody3D

func _ready() -> void:
	_build_world()
	_build_ui()

func _build_world() -> void:
	world_root = Node3D.new()
	world_root.name = "World"
	add_child(world_root)

	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	sky.sky_material = ProceduralSkyMaterial.new()
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("9dbbd1")
	environment.ambient_light_energy = 0.7
	environment_node.environment = environment
	world_root.add_child(environment_node)

	var sunlight := DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-55.0, -30.0, 0.0)
	sunlight.light_energy = 1.1
	sunlight.shadow_enabled = true
	world_root.add_child(sunlight)

	_add_box(Vector3(0.0, -0.5, 0.0), Vector3(48.0, 1.0, 48.0), Color("5d9b45"))
	_add_box(Vector3(0.0, 0.1, -8.0), Vector3(8.0, 0.2, 8.0), Color("9a7652"), false)
	_add_box(Vector3(-5.0, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("d84d3f"))
	_add_box(Vector3(-3.5, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("e8c547"))
	_add_box(Vector3(3.5, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("407ac2"))
	_add_box(Vector3(5.0, 1.0, -8.0), Vector3(1.0, 2.0, 1.0), Color("eeeeee"))

	for tree_position: Vector3 in [Vector3(-10, 0, -4), Vector3(10, 0, -5), Vector3(-9, 0, 8), Vector3(9, 0, 9)]:
		_add_box(tree_position + Vector3(0, 1.0, 0), Vector3(0.8, 2.0, 0.8), Color("76502e"))
		_add_box(tree_position + Vector3(0, 3.0, 0), Vector3(3.0, 2.5, 3.0), Color("3f883d"))

func _add_box(box_position: Vector3, box_size: Vector3, color: Color, solid: bool = true) -> void:
	var body := StaticBody3D.new()
	body.position = box_position
	body.name = "Block"
	if solid:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = box_size
		collision.shape = shape
		body.add_child(collision)

	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = box_size
	mesh_instance.mesh = box_mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	world_root.add_child(body)

func _build_ui() -> void:
	var ui_layer := CanvasLayer.new()
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
	subtitle.text = "A classic block-building revival"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(subtitle)

	var play_button := Button.new()
	play_button.text = "Play sandbox"
	play_button.custom_minimum_size = Vector2(0, 48)
	play_button.pressed.connect(_start_game)
	menu.add_child(play_button)

	var controls := Label.new()
	controls.text = "WASD: move    Space: jump\nMouse: look    Esc: release / capture mouse"
	controls.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu.add_child(controls)

	status_label = Label.new()
	status_label.text = "NOUNBLOX  •  GODOT"
	status_label.position = Vector2(18.0, 14.0)
	screen.add_child(status_label)

func _start_game() -> void:
	if player != null:
		return
	menu_panel.hide()
	player = PLAYER_SCENE.instantiate() as CharacterBody3D
	player.name = "Player"
	player.position = Vector3(0.0, 0.1, 4.0)
	world_root.add_child(player)
	status_label.text = "WASD Move  •  Space Jump  •  Esc Mouse"
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
