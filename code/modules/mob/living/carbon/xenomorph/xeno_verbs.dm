//// Holds Xeno verbs that don't belong anywhere else.
/mob/living/carbon/Xenomorph/verb/hive_status()
	set name = "Hive Status"
	set desc = "Check the status of your current hive."
	set category = "Alien"

	if(!hive.living_xeno_queen)
		to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
		return

	if(interference)
		to_chat(src, SPAN_WARNING("A headhunter temporarily cut off your psychic connection!"))
		return

	hive.hive_ui.open_hive_status(src)

/mob/living/carbon/Xenomorph/verb/toggle_xeno_mobhud()
	set name = "Toggle Xeno Status HUD"
	set desc = "Toggles the health and plasma HUD appearing above Xenomorphs."
	set category = "Alien"

	var/datum/mob_hud/H = huds[MOB_HUD_XENO_STATUS]
	if (xeno_mobhud)
		H.remove_hud_from(usr)
	else 
		H.add_hud_to(usr)

	xeno_mobhud = !xeno_mobhud

/mob/living/carbon/Xenomorph/verb/toggle_xeno_hostilehud()
	set name = "Toggle Hostile Status HUD"
	set desc = "Toggles the HUD that renders various negative status effects inflicted on humans."
	set category = "Alien"

	var/datum/mob_hud/H = huds[MOB_HUD_XENO_HOSTILE]
	if (xeno_hostile_hud)
		H.remove_hud_from(usr)
	else 
		H.add_hud_to(usr)

	xeno_hostile_hud = !xeno_hostile_hud


/mob/living/carbon/Xenomorph/verb/middle_mouse_toggle()
	set name = "Toggle Middle/Shift Clicking"
	set desc = "Toggles between using middle mouse click and shift click for selected abilitiy use."
	set category = "Alien"

	if (!client || !client.prefs)
		return

	client.prefs.toggle_prefs ^= TOGGLE_MIDDLE_MOUSE_CLICK
	client.prefs.save_preferences()
	if (client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK)
		to_chat(src, SPAN_NOTICE("The selected xeno ability will now be activated with middle mouse clicking."))
	else
		to_chat(src, SPAN_NOTICE("The selected xeno ability will now be activated with shift clicking."))

/mob/living/carbon/Xenomorph/verb/directional_attack_toggle()
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