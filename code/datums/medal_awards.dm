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

/datum/recipient_awards
	var/list/medal_names
	var/list/medal_citations
	var/list/medal_items
	var/list/posthumous
	var/recipient_rank
	var/recipient_ckey
	var/mob/recipient_mob
	var/list/giver_name // Actually key for xenos
	var/list/giver_rank // Actually name for xenos
	var/list/giver_mob

/datum/recipient_awards/New()
	medal_names = list()
	medal_citations = list()
	medal_items = list()
	posthumous = list()
	giver_name = list()
	giver_rank = list()
	giver_mob = list()


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
	var/medal_type = tgui_input_list(usr, "What type of medal do you want to award?", "Medal Type", list(MARINE_CONDUCT_MEDAL, MARINE_BRONZE_HEART_MEDAL, MARINE_VALOR_MEDAL, MARINE_HEROISM_MEDAL))
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

	if(!as_admin)
		recipient_award.giver_rank += recipient_ranks[usr.real_name] // Currently not used in marine award message
		recipient_award.giver_name += usr.real_name // Currently not used in marine award message
	else
		recipient_award.giver_rank += "([usr.ckey])" // Just because it'll be displayed in the panel
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

/proc/print_medal(mob/living/carbon/human/user, obj/printer)
	var/obj/item/card/id/card = user.wear_id
	if(!card)
		to_chat(user, SPAN_WARNING("You must have an authenticated ID Card to award medals."))
		return

	if(!((card.paygrade in GLOB.co_paygrades) || (card.paygrade in GLOB.highcom_paygrades)))
		to_chat(user, SPAN_WARNING("Only a Senior Officer can award medals!"))
		return

	if(!card.registered_ref)
		user.visible_message("ERROR: ID card not registered in USCM registry. Potential medal fraud detected.")
		return

	var/real_owner_ref = card.registered_ref

	if(real_owner_ref != WEAKREF(user))
		user.visible_message("ERROR: ID card not registered for [user.real_name] in USCM registry. Potential medal fraud detected.")
		return

	if(give_medal_award(get_turf(printer)))
		user.visible_message(SPAN_NOTICE("[printer] prints a medal."))

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
	for(var/mob/living/carbon/xenomorph/xeno in hive.totalDeadXenos)
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
	var/medal_type = tgui_input_list(usr, "What type of jelly do you want to award?", "Jelly Type", list(XENO_SLAUGHTER_MEDAL, XENO_RESILIENCE_MEDAL, XENO_SABOTAGE_MEDAL, XENO_PROLIFERATION_MEDAL, XENO_REJUVENATION_MEDAL), theme="hive_status")
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
	if(!admin_attribution)
		recipient_award.giver_rank += usr.name
		recipient_award.giver_name += usr.key
	else if(admin_attribution == "none")
		recipient_award.giver_rank += null
		recipient_award.giver_name += null
	else
		recipient_award.giver_rank += admin_attribution
		recipient_award.giver_name += null // If not null, rescinding it will take stats away from a mob with this key

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
