// APC cannons
/obj/item/hardpoint/primary/humvee_cannon
	name = "\improper M24-RC1 Remote Cannon"
	desc = "A single-barrel, remotely operated roof cannon for the M2420 JTMV-HWC. It fires 10x28mm tungsten rounds. Effective against infantry and lightly armored targets."
	icon = 'icons/obj/vehicles/hardpoints/humvee.dmi'

	icon_state = "humveecannon"
	disp_icon = "humvee"
	disp_icon_state = "humveecannon"
	activation_sounds = list('sound/weapons/humvee_cannon.ogg')

	damage_multiplier = 0.2

	health = 300
	firing_arc = 80

	origins = list(0, 0)

	ammo = new /obj/item/ammo_magazine/hardpoint/humvee_cannon
	max_clips = 4

	use_muzzle_flash = TRUE
	angle_muzzleflash = FALSE
	muzzleflash_icon_state = "muzzle_flash_small"

	muzzle_flash_pos = list(
		"1" = list(-17, -6),
		"2" = list(-16, -58),
		"4" = list(12, -31),
		"8" = list(-44, -32)
	)

	scatter = 1
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.3 SECONDS

/obj/item/hardpoint/primary/humvee_cannon/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))
