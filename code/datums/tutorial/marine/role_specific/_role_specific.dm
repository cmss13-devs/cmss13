/datum/tutorial/marine/role_specific
	category = TUTORIAL_CATEGORY_MARINE_ROLE_SPECIFIC
	parent_path = /datum/tutorial/marine/role_specific
	/// Used in HM tutorials to reference the main test dummy
	var/mob/living/carbon/human/realistic_dummy/marine_dummy
	/// For use in the handle_pill_bottle and handle_autoinjector helper, should always be set to 0 when not in use
	var/handle_helper_status = 0

/**
* Handles the creation and describes the use of pill bottles and pills in HM tutorials
*
* Currently limited to /mob/living/carbon/human/realistic_dummy
*
* Will break if used more than once per proc, see add_to_tracking_atoms() limitations
*
* Arguments:
* * target Set to realistic_dummy of choosing
* * name Uppercased name of the selected chemical, in string form
* * maptext Sets the maptext_label variable for the created pill bottle, also a string
* * iconnumber Sets the icon for the created pill bottle, input a number string ONLY (IE: "1")
* * pill Typepath of the pill to place into the pill bottle
*/

/datum/tutorial/marine/role_specific/proc/handle_pill_bottle(target, name, maptext, iconnumber, pill)
	SIGNAL_HANDLER

	if(handle_helper_status == 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		var/obj/item/storage/pill_bottle/bottle = new /obj/item/storage/pill_bottle
		medbelt.handle_item_insertion(bottle)
		medbelt.update_icon()

		bottle.name = "\improper [name] pill bottle"
		bottle.icon_state = "pill_canister[iconnumber]"
		bottle.maptext_label = "[maptext]"
		bottle.maptext = SPAN_LANGCHAT("[maptext]")
		bottle.max_storage_space = 1
		bottle.overlays.Cut()
		bottle.bottle_lid = FALSE
		bottle.overlays += "pills_closed"

		var/obj/item/reagent_container/pill/tpill = new pill(bottle) // tpill = tracking pill
		add_to_tracking_atoms(bottle)


		message_to_player("A <b>[name] Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
		message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>[name] Pill Bottle</b> to draw a pill.")

		add_highlight(medbelt, COLOR_GREEN)
		add_highlight(bottle, COLOR_GREEN)

		handle_helper_status++
		RegisterSignal(tpill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(handle_pill_bottle))
		return

	if(handle_helper_status == 1)
		message_to_player("Good. Now stand next to the Dummy, and click their body while holding the pill to feed it to them.")

		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, bottle)


		UnregisterSignal(target, COMSIG_ITEM_DRAWN_FROM_STORAGE)

		add_highlight(target, COLOR_GREEN)
		remove_highlight(medbelt)
		remove_highlight(bottle)

		handle_helper_status++
		RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(handle_pill_bottle))
		RegisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(handle_pill_bottle))

		return

	if(handle_helper_status == 2)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, bottle)

		if(target == tutorial_mob)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
			UnregisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED)
			var/mob/living/living_mob = tutorial_mob
			living_mob.rejuvenate()
			remove_highlight(bottle)
			QDEL_IN(bottle, 1 SECONDS)
			medbelt.update_icon()
			message_to_player("Don't feed yourself the pill, try again.")
			handle_helper_status = 0
			UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
			spawn(2.1 SECONDS)
			SEND_SIGNAL(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_FAIL)
			return

		else if(target == marine_dummy)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
			UnregisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED)

			remove_highlight(bottle)
			QDEL_IN(bottle, 1 SECONDS)
			handle_helper_status = 0
			SEND_SIGNAL(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
