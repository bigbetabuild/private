# Godot client prototype

This folder adds a standalone Godot 4 project alongside the existing PHP/JavaScript NOUNBLOX website. It provides a small, runnable 3D sandbox with a retro block-built starter map, a play menu, and a basic first-person controller.

## Run it

1. Install Godot 4.x.
2. Open `GodotClient/project.godot` in Godot.
3. Press **F6/F5** or click **Play sandbox**.

**Controls:** WASD to move, Space to jump, mouse to look, and Esc to release or recapture the mouse.

## Scope

This is a Godot starter client, not a full conversion of the website or its legacy Roblox client. Existing `.rbxl`/`.rbxm` places, PHP services, account system, and multiplayer protocol are not directly executable in Godot; those need separate format conversion and backend/client integration work. The sample map is generated from primitive meshes and does not depend on external assets.
