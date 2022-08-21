/mob/living/silicon/ai/death(cause, gibbed)

	if(stat == DEAD)
		return

	icon_state = "ai-crash"

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	for(var/obj/structure/machinery/computer/communications/commconsole in machines)
		if(is_admin_level(commconsole.z))
			continue
		if(istype(commconsole.loc,/turf))
			break

	for(var/obj/item/circuitboard/computer/communications/commboard in GLOB.item_list)
		if(is_admin_level(commboard.z))
			continue
		if(istype(commboard.loc,/turf) || istype(commboard.loc,/obj/item/storage))
			break

	for(var/mob/living/silicon/ai/shuttlecaller in ai_mob_list)
		if(is_admin_level(shuttlecaller.z))
			continue
		if(!shuttlecaller.stat && shuttlecaller.client && istype(shuttlecaller.loc,/turf))
			break

	if(explosive)
		addtimer(CALLBACK(src, .proc/explosion, src.loc, 3, 6, 12, 15), 10)

	for(var/obj/structure/machinery/ai_status_display/O in machines)
		spawn( 0 )
		O.mode = 2
		if(istype(loc, /obj/item/device/aicard))
			loc.icon_state = "aicard-404"

	return ..(cause, gibbed,"gives one shrill beep before falling lifeless.")
