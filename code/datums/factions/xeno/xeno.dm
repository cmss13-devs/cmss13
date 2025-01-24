/datum/faction/xenomorph
	name = "Xenomorphs"
	desc = "Xenomorph hive among the all other hives."
	code_identificator = FACTION_XENOMORPH

	color = null
	ui_color = null

	organ_faction_iff_tag_type = /obj/item/faction_tag/organ/xenomorph
	relations_pregen = RELATIONS_FACTION_XENOMORPH

/datum/faction/xenomorph/New()
	. = ..()
	faction_modules += new /datum/faction_module/hive_mind(src)

/datum/faction/xenomorph/faction_is_ally(datum/faction/faction)
	var/datum/faction_module/hive_mind/faction_module = get_faction_module(FACTION_MODULE_HIVE_MIND)
	if(!faction_module.living_xeno_queen)
		return FALSE
	. = ..()

/datum/faction/xenomorph/can_delay_round_end(mob/living/carbon/carbon)
	if(!faction_is_ally(GLOB.faction_datums[FACTION_MARINE]))
		return TRUE
	return FALSE
/*
/datum/faction/xenomorph/get_join_status(mob/new_player/user, dat)
	if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
		to_chat(user, SPAN_WARNING(user.client.auto_lang(LANGUAGE_LOBBY_ROUND_NO_JOIN)))
		return

	if(alert(user, user.client.auto_lang(LANGUAGE_LOBBY_JOIN_XENOMORPH), user.client.auto_lang(LANGUAGE_CONFIRM), user.client.auto_lang(LANGUAGE_YES), user.client.auto_lang(LANGUAGE_NO)) == user.client.auto_lang(LANGUAGE_YES))
		if(SSticker.mode.check_xeno_late_join(user))
			var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(user, 0)
			if(new_xeno && !istype(new_xeno, /mob/living/carbon/xenomorph/larva))
				SSticker.mode.transfer_xenomorph(user, new_xeno)
				user.close_spawn_windows()
*/
/*
//LANDMARKS
/datum/xeno_mark_define
	var/name = "xeno_declare"
	var/icon_state = "empty"
	var/desc = "Xenos make psychic markers with this meaning as positional lasting communication to eachother"

/datum/xeno_mark_define/fortify
	name = "Fortify"
	desc = "Fortify this area!"
	icon_state = "fortify"

/datum/xeno_mark_define/weeds
	name = "Need Weeds"
	desc = "Need weeds here!"
	icon_state = "weed"

/datum/xeno_mark_define/nest
	name = "Nest"
	desc = "Nest enemies here!"
	icon_state = "nest"

/datum/xeno_mark_define/hosts
	name = "Hosts"
	desc = "Hosts here!"
	icon_state = "hosts"

/datum/xeno_mark_define/aide
	name = "Aide"
	desc = "Aide here!"
	icon_state = "aide"

/datum/xeno_mark_define/defend
	name = "Defend"
	desc = "Defend the hive here!"
	icon_state = "defend"

/datum/xeno_mark_define/danger
	name = "Danger Warning"
	desc = "Caution, danger here!"
	icon_state = "danger"

/datum/xeno_mark_define/rally
	name = "Rally"
	desc = "Group up here!"
	icon_state = "rally"

/datum/xeno_mark_define/hold
	name = "Hold"
	desc = "Hold this area!"
	icon_state = "hold"

/datum/xeno_mark_define/ambush
	name = "Ambush"
	desc = "Ambush the enemy here!"
	icon_state = "ambush"

/datum/xeno_mark_define/attack
	name = "Attack"
	desc = "Attack the enemy here!"
	icon_state = "attack"


//HIVE STATUS
/datum/hive_status_ui
	var/name = "Hive Status"

	// Data to pass when rendering the UI (not static)
	var/total_xenos
	var/list/xeno_counts
	var/list/tier_slots
	var/list/xeno_vitals
	var/list/xeno_keys
	var/list/xeno_info
	var/faction_location
	var/burrowed_larva
	var/evolution_level

	var/data_initialized = FALSE

	var/datum/faction/assoc_hive = null

/datum/hive_status_ui/New(datum/faction/faction)
	assoc_hive = faction
	update_all_data()
	START_PROCESSING(SShive_status, src)

/datum/hive_status_ui/process()
	update_xeno_vitals()
	update_xeno_info(FALSE)
	SStgui.update_uis(src)

// Updates the list tracking how many xenos there are in each tier, and how many there are in total
/datum/hive_status_ui/proc/update_xeno_counts(send_update = TRUE)
	xeno_counts = assoc_hive.get_xeno_counts()

	total_xenos = 0
	for(var/counts in xeno_counts)
		for(var/caste in counts)
			total_xenos += counts[caste]

	if(send_update)
		SStgui.update_uis(src)

	xeno_counts[1] -= "Queen" // don't show queen in the amount of xenos

	// Also update the amount of T2/T3 slots
	tier_slots = assoc_hive.get_tier_slots()

// Updates the hive location using the area name of the defined hive location turf
/datum/hive_status_ui/proc/update_faction_location(send_update = TRUE)
	if(!assoc_hive.faction_location)
		return

	faction_location = strip_improper(get_area_name(assoc_hive.faction_location))

	if(send_update)
		SStgui.update_uis(src)

// Updates the sorted list of all xenos that we use as a key for all other information
/datum/hive_status_ui/proc/update_xeno_keys(send_update = TRUE)
	xeno_keys = assoc_hive.get_xeno_keys()

	if(send_update)
		SStgui.update_uis(src)

// Mildly related to the above, but only for when xenos are removed from the hive
// If a xeno dies, we don't have to regenerate all xeno info and sort it again, just remove them from the data list
/datum/hive_status_ui/proc/xeno_removed(mob/living/carbon/xenomorph/xenomorph)
	if(!xeno_keys)
		return

	for(var/index in 1 to length(xeno_keys))
		var/list/info = xeno_keys[index]
		if(info["nicknumber"] == xenomorph.nicknumber)

			// tried Remove(), didn't work. *shrug*
			xeno_keys[index] = null
			xeno_keys -= null
			return

	SStgui.update_uis(src)

// Updates the list of xeno names, strains and references
/datum/hive_status_ui/proc/update_xeno_info(send_update = TRUE)
	xeno_info = assoc_hive.get_xeno_info()

	if(send_update)
		SStgui.update_uis(src)

// Updates vital information about xenos such as health and location. Only info that should be updated regularly
/datum/hive_status_ui/proc/update_xeno_vitals()
	xeno_vitals = assoc_hive.get_xeno_vitals()

// Updates how many buried larva there are
/datum/hive_status_ui/proc/update_burrowed_larva(send_update = TRUE)
	burrowed_larva = assoc_hive.stored_larva
	if(SSxevolution)
		evolution_level = SSxevolution.get_evolution_boost_power(assoc_hive)
	else
		evolution_level = 1

	if(send_update)
		SStgui.update_uis(src)

// Updates all data except pooled larva
/datum/hive_status_ui/proc/update_all_xeno_data(send_update = TRUE)
	update_xeno_counts(FALSE)
	update_xeno_vitals()
	update_xeno_keys(FALSE)
	update_xeno_info(FALSE)

	if(send_update)
		SStgui.update_uis(src)

// Updates all data, including pooled larva
/datum/hive_status_ui/proc/update_all_data()
	data_initialized = TRUE
	update_all_xeno_data(FALSE)
	update_burrowed_larva(FALSE)
	SStgui.update_uis(src)

/datum/hive_status_ui/ui_state(mob/user)
	return GLOB.hive_state[assoc_hive.faction_name]

/datum/hive_status_ui/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(isobserver(user))
		return UI_INTERACTIVE

/datum/hive_status_ui/ui_data(mob/user)
	. = list()
	.["total_xenos"] = total_xenos
	.["xeno_counts"] = xeno_counts
	.["tier_slots"] = tier_slots
	.["xeno_keys"] = xeno_keys
	.["xeno_info"] = xeno_info
	.["xeno_vitals"] = xeno_vitals
	.["queen_location"] = get_area_name(assoc_hive.living_xeno_queen)
	.["faction_location"] = faction_location
	.["burrowed_larva"] = burrowed_larva
	.["evolution_level"] = evolution_level

	var/mob/living/carbon/xenomorph/queen/Q = user
	.["is_in_ovi"] = istype(Q) && Q.ovipositor

/datum/hive_status_ui/ui_static_data(mob/user)
	. = list()
	.["user_ref"] = REF(user)
	.["hive_color"] = assoc_hive.ui_color
	.["hive_name"] = assoc_hive.name

/datum/hive_status_ui/tgui_interact(mob/user, datum/tgui/ui)
	if(!assoc_hive)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HiveStatus", "[assoc_hive.name] Status")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/hive_status_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("give_plasma")
			var/mob/living/carbon/xenomorph/target_xenomorph = locate(params["target_ref"]) in GLOB.living_xeno_list
			var/mob/living/carbon/xenomorph/xenomorph = ui.user

			if(QDELETED(target_xenomorph) || target_xenomorph.stat == DEAD || target_xenomorph.statistic_exempt)
				return

			if(xenomorph.stat == DEAD)
				return

			var/datum/action/xeno_action/A = get_xeno_action_by_type(xenomorph, /datum/action/xeno_action/activable/queen_give_plasma)
			A?.use_ability_wrapper(target_xenomorph)

		if("heal")
			var/mob/living/carbon/xenomorph/target_xenomorph = locate(params["target_ref"]) in GLOB.living_xeno_list
			var/mob/living/carbon/xenomorph/xenomorph = ui.user

			if(QDELETED(target_xenomorph) || target_xenomorph.stat == DEAD || target_xenomorph.statistic_exempt)
				return

			if(xenomorph.stat == DEAD)
				return

			var/datum/action/xeno_action/A = get_xeno_action_by_type(xenomorph, /datum/action/xeno_action/activable/queen_heal)
			A?.use_ability_wrapper(target_xenomorph, TRUE)

		if("overwatch")
			var/mob/living/carbon/xenomorph/target_xenomorph = locate(params["target_ref"]) in GLOB.living_xeno_list
			var/mob/living/carbon/xenomorph/xenomorph = ui.user

			if(QDELETED(target_xenomorph) || target_xenomorph.stat == DEAD || target_xenomorph.statistic_exempt)
				return

			if(xenomorph.stat == DEAD)
				if(isobserver(xenomorph))
					var/mob/dead/observer/O = xenomorph
					O.ManualFollow(target_xenomorph)
				return

			if(!xenomorph.check_state(TRUE))
				return

			xenomorph.overwatch(target_xenomorph)
*/
