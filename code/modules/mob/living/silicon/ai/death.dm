/mob/living/silicon/ai/death(cause, gibbed)

	if(stat == DEAD)
		return

	icon_state = "ai-crash"

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	if(explosive)
		addtimer(CALLBACK(src, PROC_REF(explosion), src.loc, 3, 6, 12, 15), 10)

	for(var/obj/structure/machinery/ai_status_display/O in machines)
		spawn( 0 )
		O.mode = 2
		if (istype(loc, /obj/item/device/aicard))
			loc.icon_state = "aicard-404"

	return ..(cause, gibbed,"gives one shrill beep before falling lifeless.")
