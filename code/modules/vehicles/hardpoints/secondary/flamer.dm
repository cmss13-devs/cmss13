/obj/item/hardpoint/secondary/small_flamer
	name = "\improper LZR-N Flamer Unit"
	desc = "A secondary weapon for tanks that spews hot fire."

	icon_state = "flamer"
	disp_icon = "tank"
	disp_icon_state = "flamer"
	activation_sounds = list('sound/weapons/vehicles/flamethrower.ogg')

	health = 300
	traverse_arc = 120

	ammo = new /obj/item/ammo_magazine/hardpoint/secondary_flamer
	max_clips = 1

	use_muzzle_flash = FALSE

	var/max_range = 7

	px_offsets = list(
		"1" = list(2, 14),
		"2" = list(-2, 3),
		"4" = list(3, 0),
		"8" = list(-3, 18)
	)
	rotation_pivot = list(
		"1" = list(-2, -14),
		"2" = list(2, -3),
		"4" = list(-3, 0),
		"8" = list(3, -18)
	)

	gimbal_pivot = list(
		"1" = list(6, -6),
		"2" = list(-6, 6),
		"4" = list(-6, 6),
		"8" = list(6, 6)
	)

	scatter = 6
	fire_delay = 3.0 SECONDS

	var/flame_mode = FLAME_MODE_STREAM
	var/glob_fuel_cost = 3
	/// The reagent-based ammo/fuel deduction is done manually in handle_fire()
	ammo_cost_per_shot = 0

/obj/item/hardpoint/secondary/small_flamer/try_fire(atom/target, mob/living/user, params)
	if(get_turf(target) in owner.locs)
		to_chat(user, SPAN_WARNING("The target is too close."))
		return NONE

	return ..()


// Toggles between FLAME_MODE_STREAM and FLAME_MODE_GLOB
/obj/item/hardpoint/secondary/small_flamer/toggle_fire_mode(mob/user)
	flame_mode = (flame_mode == FLAME_MODE_STREAM) ? FLAME_MODE_GLOB : FLAME_MODE_STREAM
	to_chat(user, SPAN_NOTICE("You switch \the [src] to [flame_mode == FLAME_MODE_STREAM ? "stream" : "glob shot"] mode."))

/obj/item/hardpoint/secondary/small_flamer/handle_fire(atom/target, mob/living/user, params)
	if(flame_mode == FLAME_MODE_STREAM)
		return fire_flame_stream(target, user, max_range)

	var/datum/reagent/chem = LAZYACCESS(ammo.reagents?.reagent_list, 1)
	if(!chem || ammo.reagents.get_reagent_amount(chem.id) < glob_fuel_cost)
		click_empty(user)
		return NONE
	ammo.reagents.remove_reagent(chem.id, glob_fuel_cost)
	sync_ammo_from_reagents()
	return ..()

// Tags the freshly-generated glob projectile's ammo datum with the id of whichever fuel is actually loaded
/obj/item/hardpoint/secondary/small_flamer/generate_bullet(mob/user, turf/origin_turf)
	. = ..()
	var/obj/projectile/fired = .
	if(istype(fired?.ammo, /datum/ammo/flamethrower/tank_flamer_secondary))
		var/datum/ammo/flamethrower/tank_flamer_secondary/glob_ammo = fired.ammo
		var/datum/reagent/chem = LAZYACCESS(ammo.reagents?.reagent_list, 1)
		glob_ammo.loaded_chem_id = chem?.id
