/obj/item/hardpoint/support/flare_launcher
	name = "Mounted Flare Launcher"
	desc = "A support module for APCs that shoots flares"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "flare_launcher"
	disp_icon = "apc"
	disp_icon_state = "flare_launcher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	activatable = TRUE

	health = 500
	cooldown = 30
	accuracy = 0.7
	firing_arc = 120

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/flare_launcher
	max_clips = 3

	use_muzzle_flash = FALSE
