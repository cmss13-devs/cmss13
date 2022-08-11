GLOBAL_LIST_EMPTY(medal_awards)
GLOBAL_LIST_EMPTY(jelly_awards)

/datum/recipient_awards
	var/list/medal_names
	var/list/medal_citations
	var/list/posthumous
	var/recipient_rank
	var/list/giver_name // Actually key for xenos
	var/list/giver_rank // Actually name for xenos

/datum/recipient_awards/New()
	medal_names = list()
	medal_citations = list()
	posthumous = list()
	giver_name = list()
	giver_rank = list()




/proc/give_medal_award(medal_location, var/attributed = TRUE)
	var/list/possible_recipients = list("Cancel")
	var/list/listed_rcpt_ranks = list()
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/rcpt_name = t.fields["name"]
		listed_rcpt_ranks[rcpt_name] = t.fields["rank"]
		possible_recipients += rcpt_name
	var/chosen_recipient = tgui_input_list(usr, "Who do you want to award a medal to?", "Medal Recipient", possible_recipients)
	if(!chosen_recipient || chosen_recipient == "Cancel") return FALSE
	var/recipient_rank = listed_rcpt_ranks[chosen_recipient]
	var/posthumous = TRUE
	var/medal_type = tgui_input_list(usr, "What type of medal do you want to award?", "Medal Type", list("distinguished conduct medal", "bronze heart medal","medal of valor", "medal of exceptional heroism"))
	if(!medal_type) return FALSE
	var/citation = strip_html(input("What should the medal citation read?","Medal Citation", null, null) as message|null, MAX_PAPER_MESSAGE_LEN)
	if(!citation) return FALSE
	var/recipient_ckey
	var/recipient_mob
	var/foundOther = !attributed
	for(var/mob/M in GLOB.mob_list)
		if(attributed && M == usr)
			M.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE)
			if(foundOther)
				break
			foundOther = TRUE
		if(M.real_name == chosen_recipient)
			if(isliving(M) && M.stat != DEAD)
				posthumous = FALSE
			recipient_ckey = M.ckey
			recipient_mob = M
			if(foundOther)
				break
			foundOther = TRUE
	if(!GLOB.medal_awards[chosen_recipient])
		GLOB.medal_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/RA = GLOB.medal_awards[chosen_recipient]
	RA.recipient_rank = recipient_rank
	RA.medal_names += medal_type
	RA.medal_citations += citation
	RA.posthumous += posthumous
	if(attributed)
		RA.giver_rank += listed_rcpt_ranks[usr.real_name] // Currently not used in marine award message
		RA.giver_name += usr.real_name // Currently not used in marine award message and may need exceptions for admin granting
	else
		RA.giver_rank += null
		RA.giver_name += null

	if(recipient_ckey)
		var/datum/entity/player_entity/P = setup_player_entity(recipient_ckey)
		if(P)
			P.track_medal_earned(medal_type, recipient_mob, recipient_rank, citation, usr)

	if(medal_location)
		var/obj/item/clothing/accessory/medal/MD
		switch(medal_type)
			if("distinguished conduct medal")	MD = new /obj/item/clothing/accessory/medal/bronze/conduct(medal_location)
			if("bronze heart medal") 			MD = new /obj/item/clothing/accessory/medal/bronze/heart(medal_location)
			if("medal of valor") 				MD = new /obj/item/clothing/accessory/medal/silver/valor(medal_location)
			if("medal of exceptional heroism")	MD = new /obj/item/clothing/accessory/medal/gold/heroism(medal_location)
			else return FALSE
		MD.recipient_name = chosen_recipient
		MD.medal_citation = citation
		MD.recipient_rank = recipient_rank
	message_staff("[key_name_admin(usr)] awarded a [medal_type] to [chosen_recipient] for: \'[citation]\'.")

	return TRUE

/proc/print_medal(mob/living/carbon/human/user, var/obj/printer)
	var/obj/item/card/id/card = user.wear_id
	if(!card)
		to_chat(user, SPAN_WARNING("You must have an authenticated ID Card to award medals."))
		return
	if(!((card.paygrade in GLOB.co_paygrades) || (card.paygrade in GLOB.highcom_paygrades)))
		to_chat(user, SPAN_WARNING("Only a Senior Officer can award medals!"))
		return
	if(give_medal_award(get_turf(printer)))
		printer.visible_message(SPAN_NOTICE("[printer] prints a medal."))


/proc/give_jelly_award(var/datum/hive_status/hive, var/attributed = TRUE)
	if(!hive)
		return FALSE
	var/list/possible_recipients = list("Cancel")
	var/list/listed_rcpt_castes = list()
	// TODO: Also filter out facehuggers
	for(var/mob/living/carbon/Xenomorph/t in hive.totalXenos)
		if (t.persistent_ckey == usr.persistent_ckey) // Don't award self
			continue
		if (istype(t.caste, /datum/caste_datum/queen)) // Don't award queens (otherwise M.name has to be used below)
			continue
		if (istype(t.caste, /datum/caste_datum/larva)) // Don't award larva
			continue
		var/rcpt_name = t.name
		listed_rcpt_castes[rcpt_name] = t.caste_type
		possible_recipients += rcpt_name
	for(var/mob/living/carbon/Xenomorph/t in hive.totalDeadXenos)
		if (t.persistent_ckey == usr.persistent_ckey) // Don't award previous selves
			continue
		if (istype(t.caste, /datum/caste_datum/queen)) // Don't award previous queens
			continue
		if (istype(t.caste, /datum/caste_datum/larva)) // Don't award previous larva
			continue
		var/rcpt_name = t.name
		listed_rcpt_castes[rcpt_name] = t.caste_type
		possible_recipients += rcpt_name
	var/chosen_recipient = tgui_input_list(usr, "Who do you want to award jelly to?", "Jelly Recipient", possible_recipients)
	if(!chosen_recipient || chosen_recipient == "Cancel") return FALSE
	var/recipient_caste = listed_rcpt_castes[chosen_recipient]
	var/posthumous = TRUE
	var/medal_type = tgui_input_list(usr, "What type of jelly do you want to award?", "Jelly Type", list("royal jelly of slaughter", "royal jelly of resilience", "royal jelly of sabotage"))
	if(!medal_type) return FALSE
	var/citation = strip_html(input("What should the pheromone read?", "Jelly Pheromone", null, null) as message|null, MAX_PAPER_MESSAGE_LEN)
	if(!citation) return FALSE
	var/recipient_ckey
	var/recipient_mob
	var/foundOther = !attributed
	for(var/mob/M in GLOB.mob_list)
		if(attributed && M == usr)
			M.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE)
			if(foundOther)
				break
			foundOther = TRUE
		if(M.real_name == chosen_recipient) // real_name will not match name for a queen
			if(isliving(M) && M.stat != DEAD)
				posthumous = FALSE
			recipient_ckey = M.ckey
			recipient_mob = M
			if(foundOther)
				break
			foundOther = TRUE
	if(!GLOB.jelly_awards[chosen_recipient])
		GLOB.jelly_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/RA = GLOB.jelly_awards[chosen_recipient]
	RA.recipient_rank = recipient_caste // Currently not used in xeno award message
	RA.medal_names += medal_type // TODO: Should multiple medals be allowed?
	RA.medal_citations += citation
	RA.posthumous += posthumous
	if(attributed)
		RA.giver_rank += usr.name
		RA.giver_name += usr.key
	else
		RA.giver_rank += null
		RA.giver_name += null

	if(recipient_ckey)
		var/datum/entity/player_entity/P = setup_player_entity(recipient_ckey)
		if(P)
			P.track_medal_earned(medal_type, recipient_mob, recipient_caste, citation, usr)
	
	message_staff("[key_name_admin(usr)] awarded a [medal_type] to [chosen_recipient] for: \'[citation]\'.")

	return TRUE

/proc/remove_award(var/recipient_name, var/is_marine_medal, var/index = 1)
	if(!check_rights(R_MOD))
		return FALSE

	// Because the DB is slow, give an early message so there aren't two jumping on it
	message_staff("[key_name_admin(usr)] is deleting one of [recipient_name]'s medals...")
	
	// Find the award in the glob list
	var/datum/recipient_awards/RA
	if(is_marine_medal)
		RA = GLOB.medal_awards[recipient_name]
	else
		RA = GLOB.jelly_awards[recipient_name]
	if(!RA)
		to_chat(usr, "Error: Could not find the [is_marine_medal ? "marine" : "xeno"] awards for '[recipient_name]'!")
		return FALSE

	if(index < 1 || index > RA.medal_names.len)
		to_chat(usr, "Error: Index [index] is out of bounds!")
		return FALSE

	// Get mob references since we're only working with name
	var/mob/recipient_mob
	var/mob/giver_mob
	var/giver_name = RA.giver_name[index]
	var/foundOther = isnull(giver_name)
	for(var/mob/M in GLOB.mob_list)
		if(M.real_name == recipient_name) // Both marine and xeno recipients use real_name currently
			recipient_mob = M
			if(foundOther)
				break
			foundOther = TRUE
		if(is_marine_medal)
			if(M.real_name == giver_name)
				giver_mob = M
				if(foundOther)
					break
				foundOther = TRUE
		else
			if(M.key == giver_name)
				giver_mob = M
				if(foundOther)
					break
				foundOther = TRUE

	// Either entirely delete the award from the list, or just remove the entry if there are multiple
	var/medal_type = RA.medal_names[index]
	var/citation = RA.medal_citations[index]
	if(RA.medal_names.len == 1)
		if(is_marine_medal)
			GLOB.medal_awards.Remove(recipient_name)
		else
			GLOB.jelly_awards.Remove(recipient_name)
	else
		RA.medal_names.Cut(index, index + 1)
		RA.medal_citations.Cut(index, index + 1)
		RA.posthumous.Cut(index, index + 1)
		RA.giver_name.Cut(index, index + 1)
		RA.giver_rank.Cut(index, index + 1)

	// Remove giver's stat
	if(giver_mob)
		giver_mob.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE, -1)

	// Remove stats for recipient (this has a weakref to the mob, but theres a possibility of recipient.statistic_exempt)
	var/datum/entity/player_entity/P = setup_player_entity(recipient_mob.ckey)
	if(P)
		P.untrack_medal_earned(medal_type, recipient_mob, citation)

	message_staff("[key_name_admin(usr)] deleted [recipient_name]'s [medal_type] for for: \'[citation]\'.")

	return TRUE
