/obj/item/hardpoint/support/flare_launcher
	name = "M-87F Flare Launcher"
	desc = "A support module for APCs that shoots flares."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "flare_launcher"
	disp_icon = "apc"
	disp_icon_state = "flare_launcher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	damage_multiplier = 0.1

	activatable = TRUE

	health = 500
	firing_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/flare_launcher
	max_clips = 3

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_laser"

	muzzle_flash_pos = list(
		"1" = list(-4, -28),
		"2" = list(5, 8),
		"4" = list(-14, -6),
		"8" = list(14, -6)
	)

	scatter = 6
	fire_delay = 3.0 SECONDS

/obj/item/hardpoint/support/flare_launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
