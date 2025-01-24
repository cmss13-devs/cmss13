/*
 * Special Structures
 */
/obj/effect/alien/resin/special
	name = "Special Resin Structure"
	icon = 'icons/mob/xenos/structures64x64.dmi'
	icon_state = ""
	pixel_x = -16
	pixel_y = -16
	health = 200
	var/maxhealth = 200

	density = TRUE
	unacidable = TRUE
	anchored = TRUE
	block_range = 1

	plane = FLOOR_PLANE

	/// Tells the structure if they are being deleted because of hijack
	var/hijack_delete = FALSE

/obj/effect/alien/resin/special/Initialize(mapload)
	. = ..()

	maxhealth = health

	var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(!faction_module.add_special_structure(src))
		return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSfastobj, src)
	update_icon()

/obj/effect/alien/resin/special/Destroy()
	if(faction)
		var/datum/faction_module/hive_mind/faction_module = faction.get_faction_module(FACTION_MODULE_HIVE_MIND)
		faction_module.remove_special_structure(src)
		if(faction_module.living_xeno_queen)
			xeno_message("Hive: \A [name] has been destroyed at [sanitize_area(get_area_name(src))]!", 3, faction)
	STOP_PROCESSING(SSfastobj, src)

	. = ..()

/obj/effect/alien/resin/special/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.can_destroy_special() || M.faction != faction)
		return ..()

/obj/effect/alien/resin/special/get_projectile_hit_boolean(obj/projectile/firing_projectile)
	if(firing_projectile.original == src || firing_projectile.original == get_turf(src))
		return TRUE

	return FALSE
