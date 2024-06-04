#define MARINE_CONDUCT_MEDAL "distinguished conduct medal"
#define MARINE_BRONZE_HEART_MEDAL "bronze heart medal"
#define MARINE_VALOR_MEDAL "medal of valor"
#define MARINE_HEROISM_MEDAL "medal of exceptional heroism"

#define XENO_SLAUGHTER_MEDAL "royal jelly of slaughter"
#define XENO_RESILIENCE_MEDAL "royal jelly of resilience"
#define XENO_SABOTAGE_MEDAL "royal jelly of sabotage"
#define XENO_PROLIFERATION_MEDAL "royal jelly of proliferation"
#define XENO_REJUVENATION_MEDAL "royal jelly of rejuvenation"

GLOBAL_LIST_EMPTY(medal_awards)
GLOBAL_LIST_EMPTY(jelly_awards)
GLOBAL_LIST_EMPTY(medal_recommendations)

/datum/recipient_awards
	var/list/medal_names
	var/list/medal_citations
	var/list/medal_items
	var/list/posthumous
	var/recipient_rank
	var/recipient_ckey
	var/mob/recipient_mob
	var/list/giver_name // Designation for xenos
	var/list/giver_rank // "Name" for xenos
	var/list/giver_mob
	var/list/giver_ckey

/datum/recipient_awards/New()
	medal_names = list()
	medal_citations = list()
	medal_items = list()
	posthumous = list()
	giver_name = list()
	giver_rank = list()
	giver_mob = list()
	giver_ckey = list()

GLOBAL_LIST_INIT(human_medals, list(MARINE_CONDUCT_MEDAL, MARINE_BRONZE_HEART_MEDAL, MARINE_VALOR_MEDAL, MARINE_HEROISM_MEDAL))

/proc/give_medal_award(medal_location, as_admin = FALSE)
	if(as_admin && !check_rights(R_ADMIN))
		as_admin = FALSE

	// Pick a marine
	var/list/possible_recipients = list()
	var/list/recipient_ranks = list()
	for(var/datum/data/record/record in GLOB.data_core.general)
		var/recipient_name = record.fields["name"]
		recipient_ranks[recipient_name] = record.fields["rank"]
		possible_recipients += recipient_name
	var/chosen_recipient = tgui_input_list(usr, "Who do you want to award a medal to?", "Medal Recipient", possible_recipients)
	if(!chosen_recipient)
		return FALSE

	// Pick a medal
	var/medal_type = tgui_input_list(usr, "What type of medal do you want to award?", "Medal Type", GLOB.human_medals)
	if(!medal_type)
		return FALSE

	// Write a citation
	var/citation = strip_html(input("What should the medal citation read?", "Medal Citation", null, null) as message|null, MAX_PAPER_MESSAGE_LEN)
	if(!citation)
		return FALSE

	// Get mob information
	var/recipient_rank = recipient_ranks[chosen_recipient]
	var/posthumous = TRUE
	var/recipient_ckey
	var/mob/recipient_mob
	var/mob/giver_mob
	var/found_other = as_admin // Don't need to check for giver mob in admin mode
	for(var/mob/mob in GLOB.mob_list)
		if(!as_admin && mob == usr)
			// Giver: Increment their medals given stat
			giver_mob = mob
			mob.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE)
			if(found_other)
				break
			found_other = TRUE
		if(mob.real_name == chosen_recipient)
			// Recipient: Check if they are dead, and get some info
			// We might not get this info if gibbed, so we'd need to refactor again and find another way if we want stats always correct
			if(isliving(mob) && mob.stat != DEAD)
				posthumous = FALSE
			recipient_ckey = mob.persistent_ckey
			recipient_mob = mob
			if(found_other)
				break
			found_other = TRUE
	if(!recipient_mob)
		for(var/mob/mob in GLOB.dead_mob_list)
			if(mob.real_name == chosen_recipient)
				// Recipient: Check if they are dead?, and get some info
				// We might not get this info if gibbed, so we'd need to refactor again and find another way if we want stats always correct
				if(isliving(mob) && mob.stat != DEAD)
					posthumous = FALSE
				recipient_ckey = mob.persistent_ckey
				recipient_mob = mob
				break

	// Admin: Offer a medal_location if missing
	if(as_admin && !medal_location)
		var/medal_override = tgui_input_list(usr, "Spawn a medal? Press cancel for no item.", "Medal Location", list("On Recipient", "On Me"))
		if(medal_override == "On Recipient")
			medal_location = get_turf(recipient_mob)
			playsound(recipient_mob, 'sound/items/trayhit1.ogg', 15, FALSE)
			recipient_mob.visible_message(SPAN_DANGER("[recipient_mob] has been hit in the head by the [medal_type]."), null, null, 5)
		else if(medal_override == "On Me")
			medal_location = get_turf(usr)

	// Create the recipient_award
	if(!GLOB.medal_awards[chosen_recipient])
		GLOB.medal_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/recipient_award = GLOB.medal_awards[chosen_recipient]
	recipient_award.recipient_rank = recipient_rank
	recipient_award.recipient_ckey = recipient_ckey
	recipient_award.recipient_mob = recipient_mob
	recipient_award.giver_mob += giver_mob
	recipient_award.medal_names += medal_type
	recipient_award.medal_citations += citation
	recipient_award.posthumous += posthumous
	recipient_award.giver_ckey += usr.ckey

	if(!as_admin)
		recipient_award.giver_rank += recipient_ranks[usr.real_name] // Currently not used in marine award message
		recipient_award.giver_name += usr.real_name // Currently not used in marine award message
	else
		recipient_award.giver_rank += null
		recipient_award.giver_name += null

	// Create an actual medal item
	if(medal_location)
		var/obj/item/clothing/accessory/medal/medal
		switch(medal_type)
			if(MARINE_CONDUCT_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/bronze/conduct(medal_location)
			if(MARINE_BRONZE_HEART_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/bronze/heart(medal_location)
			if(MARINE_VALOR_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/silver/valor(medal_location)
			if(MARINE_HEROISM_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/gold/heroism(medal_location)
			else
				return FALSE
		medal.recipient_name = chosen_recipient
		medal.medal_citation = citation
		medal.recipient_rank = recipient_rank
		recipient_award.medal_items += medal
	else
		recipient_award.medal_items += null

	// Recipient: Add the medal to the player's stats
	if(recipient_ckey)
		var/datum/entity/player_entity/recipient_player = setup_player_entity(recipient_ckey)
		if(recipient_player)
			recipient_player.track_medal_earned(medal_type, recipient_mob, recipient_rank, citation, usr)

	// Inform staff of success
	message_admins("[key_name_admin(usr)] awarded a <a href='?medals_panel=1'>[medal_type]</a> to [chosen_recipient] for: \'[citation]\'.")

	return TRUE

/proc/give_medal_award_prefilled(medal_location, mob/giving_mob, chosen_recipient, recipient_rank, recipient_ckey, reason, _medal_type)
	var/list/recipient_ranks = list()
	for(var/datum/data/record/record in GLOB.data_core.general)
		var/recipient_name = record.fields["name"]
		recipient_ranks[recipient_name] = record.fields["rank"]

	if(!chosen_recipient)
		return FALSE

	// Pick a medal
	var/medal_type = _medal_type
	if(!medal_type)
		return FALSE

	// Write a citation
	var/citation = strip_html(reason)
	if(!citation)
		return FALSE

	// Get mob information
	var/posthumous = TRUE
	var/mob/recipient_mob
	var/found_other = FALSE

	for(var/mob/mob in GLOB.mob_list)
		if(mob.real_name == chosen_recipient)
			// Recipient: Check if they are dead, and get some info
			// We might not get this info if gibbed, so we'd need to refactor again and find another way if we want stats always correct
			if(isliving(mob) && mob.stat != DEAD)
				posthumous = FALSE
			recipient_mob = mob
			if(found_other)
				break
			found_other = TRUE
	if(!recipient_mob)
		for(var/mob/mob in GLOB.dead_mob_list)
			if(mob.real_name == chosen_recipient)
				// Recipient: Check if they are dead?, and get some info
				// We might not get this info if gibbed, so we'd need to refactor again and find another way if we want stats always correct
				if(isliving(mob) && mob.stat != DEAD)
					posthumous = FALSE
				recipient_mob = mob
				break

	// Create the recipient_award
	if(!GLOB.medal_awards[chosen_recipient])
		GLOB.medal_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/recipient_award = GLOB.medal_awards[chosen_recipient]
	recipient_award.recipient_rank = recipient_rank
	recipient_award.recipient_ckey = recipient_ckey
	recipient_award.recipient_mob = recipient_mob
	recipient_award.giver_mob += giving_mob
	recipient_award.medal_names += medal_type
	recipient_award.medal_citations += citation
	recipient_award.posthumous += posthumous
	recipient_award.giver_ckey += giving_mob.ckey

	recipient_award.giver_rank += recipient_ranks[giving_mob.real_name] // Currently not used in marine award message
	recipient_award.giver_name += giving_mob.real_name // Currently not used in marine award message

	// Create an actual medal item
	if(medal_location)
		var/obj/item/clothing/accessory/medal/medal
		switch(medal_type)
			if(MARINE_CONDUCT_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/bronze/conduct(medal_location)
			if(MARINE_BRONZE_HEART_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/bronze/heart(medal_location)
			if(MARINE_VALOR_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/silver/valor(medal_location)
			if(MARINE_HEROISM_MEDAL)
				medal = new /obj/item/clothing/accessory/medal/gold/heroism(medal_location)
			else
				return FALSE
		medal.recipient_name = chosen_recipient
		medal.medal_citation = citation
		medal.recipient_rank = recipient_rank
		recipient_award.medal_items += medal
	else
		recipient_award.medal_items += null

	// Recipient: Add the medal to the player's stats
	if(recipient_ckey)
		var/datum/entity/player_entity/recipient_player = setup_player_entity(recipient_ckey)
		if(recipient_player)
			recipient_player.track_medal_earned(medal_type, recipient_mob, recipient_rank, citation, giving_mob)

	// Inform staff of success
	message_admins("[key_name_admin(giving_mob)] awarded a <a href='?medals_panel=1'>[medal_type]</a> to [chosen_recipient] for: \'[citation]\'.")

	return TRUE

/proc/open_medal_panel(mob/living/carbon/human/user, obj/printer)
	var/obj/item/card/id/card = user.wear_id
	if(!card)
		to_chat(user, SPAN_WARNING("You must have an authenticated ID Card to award medals."))
		return

	if(!((card.paygrade in GLOB.co_paygrades) || (card.paygrade in GLOB.uscm_highcom_paygrades)))
		to_chat(user, SPAN_WARNING("Only a Senior Officer can award medals!"))
		return

	if(!card.registered_ref)
		user.visible_message("ERROR: ID card not registered in USCM registry. Potential medal fraud detected.")
		return

	if(!card.check_biometrics(user))
		user.visible_message("ERROR: ID card not registered for [user.real_name] in USCM registry. Potential medal fraud detected.")
		return

	GLOB.ic_medals_panel.user_locs[WEAKREF(user)] = WEAKREF(printer)
	GLOB.ic_medals_panel.tgui_interact(user)


GLOBAL_LIST_INIT(xeno_medals, list(XENO_SLAUGHTER_MEDAL, XENO_RESILIENCE_MEDAL, XENO_SABOTAGE_MEDAL, XENO_PROLIFERATION_MEDAL, XENO_REJUVENATION_MEDAL))

/proc/give_jelly_award(datum/hive_status/hive, as_admin = FALSE)
	if(!hive)
		return FALSE

	if(as_admin && !check_rights(R_ADMIN))
		as_admin = FALSE

	// Pick a xeno
	var/list/possible_recipients = list()
	var/list/recipient_castes = list()
	var/list/recipient_mobs = list()
	for(var/mob/living/carbon/xenomorph/xeno in hive.totalXenos)
		if (xeno.persistent_ckey == usr.persistent_ckey) // Don't award self
			continue
		if (xeno.tier == 0) // Don't award larva or facehuggers
			continue
		if (!as_admin && istype(xeno.caste, /datum/caste_datum/queen)) // Don't award queens unless admin
			continue
		var/recipient_name = xeno.real_name
		recipient_castes[recipient_name] = xeno.caste_type
		recipient_mobs[recipient_name] = xeno
		possible_recipients += recipient_name
	for(var/mob/living/carbon/xenomorph/xeno in hive.total_dead_xenos)
		if (xeno.persistent_ckey == usr.persistent_ckey) // Don't award previous selves
			continue
		if (xeno.tier == 0) // Don't award larva or facehuggers
			continue
		if (!as_admin && istype(xeno.caste, /datum/caste_datum/queen)) // Don't award previous queens unless admin
			continue
		var/recipient_name = xeno.real_name
		recipient_castes[recipient_name] = xeno.caste_type
		recipient_mobs[recipient_name] = xeno
		possible_recipients += recipient_name
	var/chosen_recipient = tgui_input_list(usr, "Who do you want to award jelly to?", "Jelly Recipient", possible_recipients, theme="hive_status")
	if(!chosen_recipient)
		return FALSE

	// Pick a jelly
	var/medal_type = tgui_input_list(usr, "What type of jelly do you want to award?", "Jelly Type", GLOB.xeno_medals, theme="hive_status")
	if(!medal_type)
		return FALSE

	// Write the pheromone
	var/citation = strip_html(input("What should the pheromone read?", "Jelly Pheromone", null, null) as message|null, MAX_PAPER_MESSAGE_LEN)
	if(!citation)
		return FALSE

	// Admin: Override attribution
	var/admin_attribution = null
	if(as_admin)
		admin_attribution = strip_html(input("Override the jelly attribution? Press cancel for no attribution.", "Jelly Attribution", "Queen Mother", null) as text|null, MAX_NAME_LEN)
		if(!admin_attribution) // Its actually "" but this also seems to check that
			admin_attribution = "none"

	// Get mob information
	var/recipient_caste = recipient_castes[chosen_recipient]
	var/mob/recipient_mob = recipient_mobs[chosen_recipient]
	var/mob/giver_mob
	var/recipient_ckey = recipient_mob.persistent_ckey
	var/posthumous = !isliving(recipient_mob) || recipient_mob.stat == DEAD
	if(!as_admin) // Don't need to check for giver mob in admin mode
		for(var/mob/mob in hive.totalXenos)
			if(mob == usr)
				// Giver: Increment their medals given stat
				giver_mob = mob
				mob.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE)
				break

	// Create the recipient_award
	if(!GLOB.jelly_awards[chosen_recipient])
		GLOB.jelly_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/recipient_award = GLOB.jelly_awards[chosen_recipient]
	recipient_award.recipient_rank = recipient_caste // Currently not used in xeno award message
	recipient_award.recipient_ckey = recipient_ckey
	recipient_award.recipient_mob = recipient_mob
	recipient_award.giver_mob += giver_mob
	recipient_award.medal_names += medal_type
	recipient_award.medal_citations += citation
	recipient_award.posthumous += posthumous
	recipient_award.giver_ckey += usr.ckey

	if(!admin_attribution)
		recipient_award.giver_rank += usr.name
		var/mob/living/carbon/xenomorph/giving_xeno = usr
		if(istype(giving_xeno))
			recipient_award.giver_name += giving_xeno.full_designation
		else
			recipient_award.giver_name += null
	else if(admin_attribution == "none")
		recipient_award.giver_rank += null
		recipient_award.giver_name += null
	else
		recipient_award.giver_rank += admin_attribution
		recipient_award.giver_name += null

	recipient_award.medal_items += null // TODO: Xeno award item?

	// Recipient: Add the medal to the player's stats
	if(recipient_ckey)
		var/datum/entity/player_entity/recipient_player = setup_player_entity(recipient_ckey)
		if(recipient_player)
			recipient_player.track_medal_earned(medal_type, recipient_mob, recipient_caste, citation, usr)

	// Inform staff of success
	message_admins("[key_name_admin(usr)] awarded a <a href='?medals_panel=1'>[medal_type]</a> to [chosen_recipient] for: \'[citation]\'.")

	return TRUE

/proc/remove_award(recipient_name, is_marine_medal, index = 1)
	if(!check_rights(R_MOD))
		return FALSE

	// Because the DB is slow, give an early message so there aren't two jumping on it
	message_admins("[key_name_admin(usr)] is deleting one of [recipient_name]'s medals...")

	// Find the award in the glob list
	var/datum/recipient_awards/recipient_award
	if(is_marine_medal)
		recipient_award = GLOB.medal_awards[recipient_name]
	else
		recipient_award = GLOB.jelly_awards[recipient_name]
	if(!recipient_award)
		to_chat(usr, "Error: Could not find the [is_marine_medal ? "marine" : "xeno"] awards for '[recipient_name]'!")
		return FALSE

	if(index < 1 || index > recipient_award.medal_names.len)
		to_chat(usr, "Error: Index [index] is out of bounds!")
		return FALSE

	// Get mob references since we're only working with name
	var/mob/recipient_mob = recipient_award.recipient_mob
	var/mob/giver_mob = recipient_award.giver_mob[index]

	// Delete the physical award item
	var/obj/item/medal_item = recipient_award.medal_items[index]
	if(medal_item)
		// Marine medals
		if(istype(medal_item, /obj/item/clothing/accessory))
			var/obj/item/clothing/accessory/marine_accessory = medal_item
			if(marine_accessory.has_suit)
				var/obj/item/clothing/attached_clothing = marine_accessory.has_suit
				attached_clothing.remove_accessory(usr, marine_accessory)
		// Update any container
		if(istype(medal_item.loc, /obj/item/storage))
			var/obj/item/storage/container = medal_item.loc
			container.update_icon()
		// Now delete it
		qdel(medal_item)

	// Either entirely delete the award from the list, or just remove the entry if there are multiple
	var/medal_type = recipient_award.medal_names[index]
	var/citation = recipient_award.medal_citations[index]
	if(recipient_award.medal_names.len == 1)
		if(is_marine_medal)
			GLOB.medal_awards.Remove(recipient_name)
		else
			GLOB.jelly_awards.Remove(recipient_name)
	else
		recipient_award.medal_names.Cut(index, index + 1)
		recipient_award.medal_citations.Cut(index, index + 1)
		recipient_award.posthumous.Cut(index, index + 1)
		recipient_award.giver_name.Cut(index, index + 1)
		recipient_award.giver_rank.Cut(index, index + 1)
		recipient_award.giver_mob.Cut(index, index + 1)
		recipient_award.giver_ckey.Cut(index, index + 1)
		recipient_award.medal_items.Cut(index, index + 1)

	// Remove giver's stat
	if(giver_mob)
		giver_mob.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE, -1)

	// Remove stats for recipient (this has a weakref to the mob, but theres a possibility of recipient.statistic_exempt)
	if(recipient_mob)
		var/datum/entity/player_entity/recipient_player = setup_player_entity(recipient_mob.persistent_ckey)
		if(recipient_player)
			recipient_player.untrack_medal_earned(medal_type, recipient_mob, citation)

	// Inform staff of success
	message_admins("[key_name_admin(usr)] deleted [recipient_name]'s <a href='?medals_panel=1'>[medal_type]</a> for: \'[citation]\'.")

	return TRUE

/datum/medal_recommendation
	var/recipient_rank
	var/recipient_ckey
	var/recipient_name
	var/recommended_by_name
	var/recommended_by_ckey
	var/reason
	var/recommended_by_rank


/proc/add_medal_recommendation(mob/recommendation_giver)
	// Pick a marine
	var/list/possible_recipients = list()
	var/list/recipient_ranks = list()
	for(var/datum/data/record/record in GLOB.data_core.general)
		var/recipient_name = record.fields["name"]
		if(recipient_name == recommendation_giver.real_name)
			continue
		recipient_ranks[recipient_name] = record.fields["rank"]
		possible_recipients += recipient_name
	if(length(possible_recipients) == 0)
		to_chat(recommendation_giver, SPAN_WARNING("It's not possible to give medals when the ship is empty. Tough luck, partner..."))
		return FALSE

	var/chosen_recipient = tgui_input_list(recommendation_giver, "Who do you want to recommend a medal for?", "Medal Recommendation", possible_recipients)
	if(!chosen_recipient)
		return FALSE

	// Write a citation
	var/reason = strip_html(tgui_input_text(recommendation_giver, "Why does this person deserve a medal?", "Medal Recommendation", null, MAX_PAPER_MESSAGE_LEN, TRUE), MAX_PAPER_MESSAGE_LEN)
	if(!reason)
		return FALSE

	// Get mob information
	var/recipient_rank = recipient_ranks[chosen_recipient]
	var/recipient_ckey
	var/mob/recipient_mob
	var/found_other = FALSE

	for(var/mob/mob in GLOB.mob_list)
		if(mob.real_name == chosen_recipient)
			// We might not get this info if gibbed, so we'd need to refactor again and find another way if we want stats always correct
			recipient_ckey = mob.persistent_ckey
			recipient_mob = mob
			if(found_other)
				break
			found_other = TRUE
	if(!recipient_mob)
		for(var/mob/mob in GLOB.dead_mob_list)
			if(mob.real_name == chosen_recipient)
				// Recipient: Check if they are dead?, and get some info
				// We might not get this info if gibbed, so we'd need to refactor again and find another way if we want stats always correct
				recipient_ckey = mob.persistent_ckey
				recipient_mob = mob
				break

	// Create the recipient_award
	var/datum/medal_recommendation/recommendation = new /datum/medal_recommendation()
	GLOB.medal_recommendations += recommendation

	recommendation.recipient_rank = recipient_rank
	recommendation.recipient_ckey = recipient_ckey
	recommendation.recipient_name = recipient_mob.real_name
	recommendation.recommended_by_name = recommendation_giver.real_name
	recommendation.recommended_by_ckey = recommendation_giver.ckey
	recommendation.recommended_by_rank = recipient_ranks[recommendation_giver.real_name]


	recommendation.reason = reason

	return TRUE


GLOBAL_DATUM_INIT(ic_medals_panel, /datum/ic_medal_panel, new)

/datum/ic_medal_panel
	var/name = "Medals Panel"
	var/list/datum/weakref/user_locs = list()

/datum/ic_medal_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IcMedalsPanel", "Medals Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/ic_medal_panel/ui_state(mob/user)
	var/datum/weakref/user_reference = WEAKREF(user)
	var/datum/weakref/loc_reference = user_locs[user_reference]
	if(istype(loc_reference?.resolve(), /obj/item))
		return GLOB.not_incapacitated_and_inventory_state
	else
		return GLOB.not_incapacitated_and_adjacent_state

/datum/ic_medal_panel/ui_host(mob/user)
	. = ..()
	var/datum/weakref/user_reference = WEAKREF(user)
	var/datum/weakref/loc_reference = user_locs[user_reference]
	. = loc_reference?.resolve()

/datum/ic_medal_panel/ui_data(mob/user)
	var/list/data = list()
	data["recommendations"] = list()

	for(var/datum/medal_recommendation/recommendation in GLOB.medal_recommendations)
		var/recommendation_list = list()

		recommendation_list["rank"] = recommendation.recipient_rank
		recommendation_list["name"] = recommendation.recipient_name
		recommendation_list["ref"] = REF(recommendation)
		recommendation_list["recommender_name"] = recommendation.recommended_by_name
		recommendation_list["reason"] = recommendation.reason
		recommendation_list["recommender_rank"] = recommendation.recommended_by_rank

		data["recommendations"] += list(recommendation_list)
	return data

/datum/ic_medal_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/user = usr
	var/obj/item/card/id/card = user.wear_id
	if(!card)
		to_chat(user, SPAN_WARNING("You must have an authenticated ID Card to award medals."))
		return

	if(!((card.paygrade in GLOB.co_paygrades) || (card.paygrade in GLOB.uscm_highcom_paygrades)))
		to_chat(user, SPAN_WARNING("Only a Senior Officer can award medals!"))
		return

	if(!card.registered_ref)
		user.visible_message("ERROR: ID card not registered in USCM registry. Potential medal fraud detected.")
		return

	var/real_owner_ref = card.registered_ref

	if(real_owner_ref != WEAKREF(user))
		user.visible_message("ERROR: ID card not registered for [user.real_name] in USCM registry. Potential medal fraud detected.")
		return

	var/datum/weakref/user_ref = WEAKREF(user)
	var/datum/weakref/loc_ref = user_locs[user_ref]
	var/atom/actual_loc = loc_ref?.resolve()
	if(!actual_loc)
		return

	switch(action)
		if("grant_new_medal")
			if(give_medal_award(get_turf(actual_loc)))
				actual_loc.visible_message(SPAN_NOTICE("[actual_loc] prints a medal."))
			. = TRUE

		if("approve_medal")
			var/recommendation_ref = params["ref"]
			var/medal_type = params["medal_type"]
			if(!(medal_type in GLOB.human_medals))
				return
			var/datum/medal_recommendation/recommendation = locate(recommendation_ref) in GLOB.medal_recommendations
			if(!recommendation)
				return
			if(recommendation.recipient_name == user.real_name)
				to_chat(user, SPAN_WARNING("You cannot give medals to yourself!"))
				return

			var/choice = tgui_alert(user, "Would you like to change the medal text?", "Medal Citation", list("Yes", "No"))
			var/medal_citation = recommendation.reason
			if(choice == "Yes")
				medal_citation = strip_html(tgui_input_text(user, "What should the medal citation read?", "Medal Citation", null, MAX_PAPER_MESSAGE_LEN, TRUE), MAX_PAPER_MESSAGE_LEN)

			var/confirm_choice = tgui_alert(user, "Are you sure you want to give a medal to [recommendation.recipient_name]?", "Medal Confirmation", list("Yes", "No"))
			if(confirm_choice != "Yes")
				return

			if(give_medal_award_prefilled(get_turf(actual_loc), user, recommendation.recipient_name, recommendation.recipient_rank, recommendation.recipient_ckey, medal_citation, medal_type, recommendation.recommended_by_ckey, recommendation.recommended_by_name))
				GLOB.medal_recommendations -= recommendation
				qdel(recommendation)
				user.visible_message(SPAN_NOTICE("[actual_loc] prints a medal."))
				. = TRUE

		if("deny_medal")
			var/recommendation_ref = params["ref"]
			var/datum/medal_recommendation/recommendation = locate(recommendation_ref) in GLOB.medal_recommendations
			if(!recommendation)
				return
			var/confirm = tgui_alert(user, "Are you sure you want to deny this medal recommendation?", "Medal Confirmation", list("Yes", "No"))
			if(confirm != "Yes")
				return
			GLOB.medal_recommendations -= recommendation
			qdel(recommendation)
			. = TRUE

/datum/ic_medal_panel/ui_close(mob/user)
	. = ..()
	user_locs -= WEAKREF(user)

/datum/ic_medal_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/medal)
	)
