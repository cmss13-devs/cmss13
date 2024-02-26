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

	var/datum/hive_status/linked_hive

	plane = FLOOR_PLANE

	/// Tells the structure if they are being deleted because of hijack
	var/hijack_delete = FALSE

/obj/effect/alien/resin/special/Initialize(mapload, hive_ref)
	. = ..()
	maxhealth = health

	if(hive_ref)
		linked_hive = hive_ref
	else
		linked_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]

	set_hive_data(src, linked_hive.hivenumber)

	if(!linked_hive.add_special_structure(src))
		return INITIALIZE_HINT_QDEL

	START_PROCESSING(SSfastobj, src)
	update_icon()

/obj/effect/alien/resin/special/Destroy()
	if(linked_hive)
		linked_hive.remove_special_structure(src)
		if(linked_hive.living_xeno_queen)
			xeno_message("Hive: \A [name] has been destroyed at [sanitize_area(get_area_name(src))]!", 3, linked_hive.hivenumber)
	linked_hive = null
	STOP_PROCESSING(SSfastobj, src)

	. = ..()

/obj/effect/alien/resin/special/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.can_destroy_special() || M.hivenumber != linked_hive.hivenumber)
		return ..()

/obj/effect/alien/resin/special/get_projectile_hit_boolean(obj/projectile/firing_projectile)
	if(firing_projectile.original == src || firing_projectile.original == get_turf(src))
		return TRUE

	return FALSE
