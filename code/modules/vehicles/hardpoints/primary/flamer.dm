/obj/item/hardpoint/primary/flamer
	name = "\improper DRG-N Offensive Flamer Unit"
	desc = "A primary weapon for the tank that spews out high-combustion napalm in a wide radius. The fuel burns intensely and quickly, which allows for it to be used offensively by armoured vehicles."

	icon_state = "drgn_flamer"
	disp_icon = "tank"
	disp_icon_state = "drgn_flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 400
	traverse_arc = 110

	ammo = new /obj/item/ammo_magazine/hardpoint/primary_flamer
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 27),
		"2" = list(0, -26),
		"4" = list(32, 1),
		"8" = list(-32, 1)
	)
	rotation_pivot = list(
		"1" = list(0, -27),
		"2" = list(0, 26),
		"4" = list(-32, -1),
		"8" = list(32, -1)
	)

	use_muzzle_flash = FALSE

	scatter = 5
	fire_delay = 3.0 SECONDS

	var/flame_mode = FLAME_MODE_GLOB
	// Flat fuel cost for a single FLAME_MODE_GLOB shot
	var/glob_fuel_cost = 5
	// The reagent-based ammo/fuel deduction is done manually in handle_fire() below
	ammo_cost_per_shot = 0

/obj/item/hardpoint/primary/flamer/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/obj/item/hardpoint/primary/flamer/try_fire(atom/target, mob/living/user, params)
	if(get_turf(target) in owner.locs)
		to_chat(user, SPAN_WARNING("The target is too close."))
		return NONE

	return ..()

// Toggles between FLAME_MODE_GLOB and FLAME_MODE_STREAM
/obj/item/hardpoint/primary/flamer/toggle_fire_mode(mob/user)
	flame_mode = (flame_mode == FLAME_MODE_STREAM) ? FLAME_MODE_GLOB : FLAME_MODE_STREAM
	to_chat(user, SPAN_NOTICE("You switch \the [src] to [flame_mode == FLAME_MODE_STREAM ? "stream" : "glob shot"] mode."))

/obj/item/hardpoint/primary/flamer/get_flame_mode()
	return flame_mode

/obj/item/hardpoint/primary/flamer/handle_fire(atom/target, mob/living/user, params)
	// A smoke tank overrides flame_mode entirely and always disperses smoke, like the M240.
	if(istype(ammo, /obj/item/ammo_magazine/hardpoint/primary_flamer/smoke))
		return fire_smoke_stream(target, user, DRG_N_SMOKE_RANGE, DRG_N_SMOKE_UNITS)

	if(flame_mode == FLAME_MODE_STREAM)
		// FLAMESHAPE_TRIANGLE is a fixed weapon trait matching the DRG-N's "wide radius" flavor text.
		// DRG_N_STREAM_RANGE_BONUS is a flat extra reach on top of the loaded fuel's own chem.rangefire.
		return fire_flame_stream(target, user, FLAMESHAPE_TRIANGLE, range_bonus = DRG_N_STREAM_RANGE_BONUS)

	var/datum/reagent/chem = LAZYACCESS(ammo.reagents?.reagent_list, 1)
	if(!chem || ammo.reagents.get_reagent_amount(chem.id) < glob_fuel_cost)
		click_empty(user)
		return NONE
	ammo.reagents.remove_reagent(chem.id, glob_fuel_cost)
	sync_ammo_from_reagents()
	return ..()

// Tags the fired glob with whichever fuel is loaded, and tints it to match.
// Glob range doesn't depend on chem.rangefire, it always reaches its targeted tile.
/obj/item/hardpoint/primary/flamer/generate_bullet(mob/user, turf/origin_turf)
	. = ..()
	var/obj/projectile/fired = .
	if(istype(fired?.ammo, /datum/ammo/flamethrower/tank_flamer))
		var/datum/ammo/flamethrower/tank_flamer/glob_ammo = fired.ammo
		glob_ammo.max_range += DRG_N_GLOB_RANGE_BONUS
		var/datum/reagent/chem = LAZYACCESS(ammo.reagents?.reagent_list, 1)
		glob_ammo.loaded_chem_id = chem?.id
		if(chem)
			fired.color = chem.burncolor
			fired.hit_effect_color = chem.burncolor

// Layers an overlay on the mounted/turret sprite, colored via mix_color_from_reagents() to match whatever fuel is currently loaded
/obj/item/hardpoint/primary/flamer/get_icon_image(x_offset, y_offset, new_dir)
	var/image/base_image = ..()
	var/image/strip = image(icon = disp_icon, icon_state = "drgn_flamer_strip", dir = new_dir)
	if(ammo?.reagents && length(ammo.reagents.reagent_list))
		strip.color = mix_color_from_reagents(ammo.reagents.reagent_list)
	base_image.overlays += strip
	return base_image
