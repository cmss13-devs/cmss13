// APC cannons
/obj/item/hardpoint/primary/dualcannon
	name = "PARS-159 Boyars Dualcannon"
	desc = "A primary two-barrel cannon for the APC that shoots 20mm IFF-compatible rounds."
	icon = 'icons/obj/vehicles/hardpoints/apc.dmi'

	icon_state = "dual_cannon"
	disp_icon = "apc"
	disp_icon_state = "dualcannon"
	activation_sounds = list('sound/weapons/vehicles/dual_autocannon_fire.ogg')

	damage_multiplier = 0.2

	health = 500
	firing_arc = 60

	origins = list(0, 1)

	ammo = new /obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	max_clips = 2

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_double"

	muzzle_flash_pos = list(
		"1" = list(11, -29),
		"2" = list(-11, 10),
		"4" = list(-14, 9),
		"8" = list(14, 9)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.3 SECONDS

/obj/item/hardpoint/primary/dualcannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
