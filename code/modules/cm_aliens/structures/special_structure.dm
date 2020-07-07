/*
 * Special Structures
 */

/proc/get_xeno_structure_desc(var/name)
	var/message
	switch(name)
		if(XENO_STRUCTURE_CORE)
			message = "<B>[XENO_STRUCTURE_CORE]</B> - Heart of the hive, grows hive weeds (which are necessary for other structures), stores resources and protects the hive from skyfire."
		if(XENO_STRUCTURE_PYLON)
			message = "<B>[XENO_STRUCTURE_PYLON]</B> - Remote section of the hive, grows hive weeds (which are necessary for other structures), stores resources and protects sisters from skyfire."
		if(XENO_STRUCTURE_POOL)
			message = "<B>[XENO_STRUCTURE_POOL]</B> - Respawns xenomorphs that fall in battle."
		if(XENO_STRUCTURE_EGGMORPH)
			message = "<B>[XENO_STRUCTURE_EGGMORPH]</B> - Processes hatched hosts into new eggs."
		if(XENO_STRUCTURE_EVOPOD)
			message = "<B>[XENO_STRUCTURE_EVOPOD]</B> - Grants an additional 0.2 evolution per tick for all sisters on weeds."
		if(XENO_STRUCTURE_RECOVERY)
			message = "<B>[XENO_STRUCTURE_RECOVERY]</B> - Hastily recovers the strength of sisters resting around it."
	return message

/obj/effect/alien/resin/special
	name = "Special Resin Structure"
	icon = 'icons/mob/xenos/structures64x64.dmi'
	pixel_x = -16
	pixel_y = -16
	health = 200
	density = TRUE
	unacidable = TRUE
	anchored = TRUE
	var/datum/hive_status/linked_hive
	var/delete_on_hijack = TRUE

/obj/effect/alien/resin/special/New(loc, var/hive_ref)
	..()
	if(hive_ref)
		linked_hive = hive_ref
		set_hive_data(src, linked_hive.hivenumber)

		if(!linked_hive.add_special_structure(src))
			qdel(src)
			return
	else
		linked_hive = hive_datum[XENO_HIVE_NORMAL]
	fast_objects.Add(src)
	update_icon()

/obj/effect/alien/resin/special/Dispose()
	if(linked_hive)
		linked_hive.remove_special_structure(src)
		if(linked_hive.living_xeno_queen)
			xeno_message("Hive: \A [name] has been destroyed at [sanitize(get_area(src))]!", 3, linked_hive.hivenumber)
	linked_hive = null
	fast_objects.Remove(src)
	. = ..()

/obj/effect/alien/resin/special/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.can_destroy_special() || M.hivenumber != linked_hive.hivenumber)
		return ..()
