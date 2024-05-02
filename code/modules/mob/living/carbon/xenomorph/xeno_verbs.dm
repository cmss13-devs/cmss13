//// Holds Xeno verbs that don't belong anywhere else.
/mob/living/carbon/xenomorph/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of our current hive."
	set category = "Alien"

	if(!hive)
		return

	if(!hive.living_xeno_queen && !hive.allow_no_queen_actions) //No Hive status on WO
		to_chat(src, SPAN_WARNING("There is no Queen. We are alone."))

		return

	if(interference)
		to_chat(src, SPAN_WARNING("A headhunter temporarily cut off our psychic connection!"))
		return

	hive.hive_ui.open_hive_status(src)

/mob/living/carbon/xenomorph/verb/hive_alliance_status()
	set name = "Hive Alliance Status"
	set desc = "Check the status of your alliances."
	set category = "Alien"

	if(!hive)
		return

	if(hive.hivenumber == XENO_HIVE_RENEGADE) //Renegade's ability to attack someone depends on IFF settings, not on alliance
		if(!iff_tag)
			to_chat(src, SPAN_NOTICE("You are not obligated to protect anyone."))
			return
		to_chat(src, SPAN_NOTICE("You seem compelled to protect [english_list(iff_tag.faction_groups, "no one")]."))
		return

	if((!hive.living_xeno_queen || check_wo()) && !hive.allow_no_queen_actions) //No Hive status on WO
		to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
		return

	if(interference)
		to_chat(src, SPAN_WARNING("A headhunter temporarily cut off your psychic connection!"))
		return

	hive.faction_ui.tgui_interact(src)

/mob/living/carbon/xenomorph/verb/clear_built_structures()
	set name = "Clear Built Structures"
	set desc = "Clears your current built structures that are tied to you."
	set category = "Alien"

	if(!length(built_structures))
		to_chat(usr, SPAN_WARNING("You don't have any built structures!"))
		return

	var/list/options = list()
	for(var/i in built_structures)
		var/atom/A = i
		options[initial(A.name)] = i

	var/input = tgui_input_list(usr, "Choose a structure type to clear", "Clear Built Structures", options, theme="hive_status")

	if(!input)
		return

	var/type = options[input]

	var/cleared_amount = 0
	for(var/i in built_structures[type])
		cleared_amount++
		built_structures[type] -= i
		if(isturf(i))
			var/turf/T = i
			T.ScrapeAway()
			continue
		qdel(i)

	to_chat(usr, SPAN_INFO("Destroyed [cleared_amount] of [input]."))


/mob/living/carbon/xenomorph/verb/toggle_xeno_mobhud()
	set name = "Toggle Xeno Status HUD"
	set desc = "Toggles the health and plasma HUD appearing above Xenomorphs."
	set category = "Alien"

	var/datum/mob_hud/H = GLOB.huds[MOB_HUD_XENO_STATUS]
	if (xeno_mobhud)
		H.remove_hud_from(usr, usr)
	else
		H.add_hud_to(usr, usr)

	xeno_mobhud = !xeno_mobhud

/mob/living/carbon/xenomorph/verb/toggle_xeno_hostilehud()
	set name = "Toggle Hostile Status HUD"
	set desc = "Toggles the HUD that renders various negative status effects inflicted on humans."
	set category = "Alien"

	var/datum/mob_hud/H = GLOB.huds[MOB_HUD_XENO_HOSTILE]
	if (xeno_hostile_hud)
		H.remove_hud_from(usr, usr)
	else
		H.add_hud_to(usr, usr)

	xeno_hostile_hud = !xeno_hostile_hud


/mob/living/carbon/xenomorph/verb/middle_mouse_toggle()
	set name = "Toggle Middle/Shift Clicking"
	set desc = "Toggles between using middle mouse click and shift click for selected ability use."
	set category = "Alien"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_MIDDLE_MOUSE_CLICK
	client.prefs.save_preferences()
	if (client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK)
		to_chat(src, SPAN_NOTICE("The selected xeno ability will now be activated with middle mouse clicking."))
	else
		to_chat(src, SPAN_NOTICE("The selected xeno ability will now be activated with shift clicking."))

/mob/living/carbon/xenomorph/verb/ability_deactivation_toggle()
	set name = "Toggle Ability Deactivation"
	set desc = "Toggles whether you can deactivate your currently active ability when re-selecting it."
	set category = "Alien"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_ABILITY_DEACTIVATION_OFF
	client.prefs.save_preferences()
	if (client.prefs.toggle_prefs & TOGGLE_ABILITY_DEACTIVATION_OFF)
		to_chat(src, SPAN_NOTICE("Your current ability can no longer be toggled off when re-selected."))
	else
		to_chat(src, SPAN_NOTICE("Your current ability can be toggled off when re-selected."))

/mob/living/carbon/xenomorph/verb/directional_attack_toggle()
	set name = "Toggle Directional Attacks"
	set desc = "Toggles the use of directional assist attacks."
	set category = "Alien"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_DIRECTIONAL_ATTACK
	client.prefs.save_preferences()
	if(client.prefs.toggle_prefs & TOGGLE_DIRECTIONAL_ATTACK)
		to_chat(src, SPAN_NOTICE("Attacks will now use directional assist."))
	else
		to_chat(src, SPAN_NOTICE("Attacks will no longer use directional assist."))

/mob/living/carbon/xenomorph/cancel_camera()
	. = ..()

	if(observed_xeno)
		overwatch(observed_xeno, TRUE)

// /mob/living/carbon/xenomorph/verb/enter_tree()
// set name = "Enter Techtree"
// set desc = "Enter the Xenomorph techtree"
// set category = "Alien.Techtree"

// var/datum/techtree/T = GET_TREE(TREE_XENO)
// T.enter_mob(src)
