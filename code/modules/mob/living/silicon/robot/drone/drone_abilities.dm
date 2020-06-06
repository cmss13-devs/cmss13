// DRONE ABILITIES
/mob/living/silicon/robot/drone/verb/set_mail_tag()
	set name = "Set Mail Tag"
	set desc = "Tag yourself for delivery through the disposals system."
	set category = "Drone"

	var/new_tag = input("Select the desired destination.", "Set Mail Tag", null) as null|anything in tagger_locations

	if(!new_tag)
		mail_destination = ""
		return

	to_chat(src, SPAN_NOTICE(" You configure your internal beacon, tagging yourself for delivery to '[new_tag]'."))
	mail_destination = new_tag

	//Auto flush if we use this verb inside a disposal chute.
	var/obj/structure/machinery/disposal/D = src.loc
	if(istype(D))
		to_chat(src, SPAN_NOTICE(" \The [D] acknowledges your signal."))
		D.flush_count = D.flush_after_ticks

	return

//Actual picking-up event.
/mob/living/silicon/robot/drone/attack_hand(mob/living/carbon/human/M as mob)

	if(M.a_intent == HELP_INTENT)
		get_scooped(M)
	..()