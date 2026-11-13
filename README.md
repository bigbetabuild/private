# NOUNBLOX: "An Good Nostalgia"
A roblox 2009 revival. 

## Native Godot client

The repository root is now also a Godot 4 project. Open the root `project.godot` in Godot 4.x and press **F6/F5** to launch the native sandbox. The reusable game scene and player scene are in `GodotClient/`.

The prototype has a generated block-world, third-person movement, jumping, mouse look, and a menu. Controls: **WASD** to move, **Space** to jump, **mouse** to look, **Esc** to release/capture the mouse.

This makes the sandbox natively runnable in Godot; it does not automatically convert the original PHP/MySQL website, legacy Roblox places (`.rbxl`/`.rbxm`), or their client/server services. Those require separate porting and conversion work.

# OVERVIEW AND SETUP

This site was originally hosted up on Ct8, however you can setup on any supported host. CT8 Seems to have weird issues copying, so copy each folder once at a time, to see what is the issue.

You must edit the DB.PHP file in the core folder to connect to a database. The SQL is in the root folder. Put this in phpmyadmin when you make a database with mysql.

# RENDER AND CLIENT 

You must patch your own client, and rendering service on RCC. This version of Nounblox used the 2016 version of rcc for rendering, and 2010L for client.

# AGREEMENTS

This source is open source, however you must change the name of the revival and make your edits open source as well. This is something to learn and jumpstart from, not to skid off without credit.

# CREDITS

NolanWhy and 608: Backend and Frontend edits.

Catzlol: Main owner of the original website.

All the previous moderators on NOUNBLOX.
