/obj/item/hardpoint/gun/flare_launcher
	name = "mounted flare launcher"
	desc = "A support module for APCs that shoots flares"
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "flare_launcher"
	disp_icon = "apc"
	disp_icon_state = "flare_launcher"
	firing_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	slot = HDPT_SUPPORT
	hdpt_layer = HDPT_LAYER_SUPPORT

	point_cost = 250
	health = 500
	damage_multiplier = 0.075
	cooldown = 30
	accuracy = 0.7
	firing_arc = 120

	origins = list(0, -2)

	ammo = new /obj/item/ammo_magazine/hardpoint/flare_launcher
	max_clips = 3

	use_muzzle_flash = FALSE
