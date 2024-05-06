/obj/item/hardpoint/secondary/grenade_launcher
	name = "M92T Grenade Launcher"
	desc = "A secondary weapon for tanks that shoots grenades."

	icon_state = "glauncher"
	disp_icon = "tank"
	disp_icon_state = "glauncher"
	activation_sounds = list('sound/weapons/gun_m92_attachable.ogg')

	health = 500
	firing_arc = 90

	ammo = new /obj/item/ammo_magazine/hardpoint/tank_glauncher
	max_clips = 3

	use_muzzle_flash = FALSE

	px_offsets = list(
		"1" = list(0, 17),
		"2" = list(0, 0),
		"4" = list(6, 0),
		"8" = list(-6, 17)
	)

	scatter = 10
	fire_delay = 3.0 SECONDS

/obj/item/hardpoint/secondary/grenade_launcher/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/secondary/grenade_launcher/try_fire(atom/target, mob/living/user, params)
	if(get_turf(target) in owner.locs)
		to_chat(user, SPAN_WARNING("The target is too close."))
		return NONE

	return ..()
