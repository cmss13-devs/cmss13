GLOBAL_LIST_EMPTY(medal_awards)

/datum/recipient_awards
	var/list/medal_names
	var/list/medal_citations
	var/list/posthumous
	var/recipient_rank

/datum/recipient_awards/New()
	medal_names = list()
	medal_citations = list()
	posthumous = list()




/proc/give_medal_award(medal_location)
	var/list/possible_recipients = list("Cancel")
	var/list/listed_rcpt_ranks = list()
	for(var/datum/data/record/t in GLOB.data_core.general)
		var/rcpt_name = t.fields["name"]
		listed_rcpt_ranks[rcpt_name] = t.fields["rank"]
		possible_recipients += rcpt_name
	var/chosen_recipient = tgui_input_list(usr, "Who do you want to award a medal to?", "Medal Recipient", possible_recipients)
	if(!chosen_recipient || chosen_recipient == "Cancel") return
	var/recipient_rank = listed_rcpt_ranks[chosen_recipient]
	var/posthumous = TRUE
	var/medal_type = tgui_input_list(usr, "What type of medal do you want to award?", "Medal Type", list("distinguished conduct medal", "bronze heart medal","medal of valor", "medal of exceptional heroism"))
	if(!medal_type) return
	var/citation = strip_html(input("What should the medal citation read?","Medal Citation", null, null) as message|null, MAX_PAPER_MESSAGE_LEN)
	if(!citation) return
	var/recipient_ckey
	var/recipient_mob
	for(var/mob/M in GLOB.mob_list)
		if(M == usr)
			M.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE)
		if(M.real_name == chosen_recipient)
			if(isliving(M) && M.stat != DEAD)
				posthumous = FALSE
			recipient_ckey = M.ckey
			recipient_mob = M
			break
	if(!GLOB.medal_awards[chosen_recipient])
		GLOB.medal_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/RA = GLOB.medal_awards[chosen_recipient]
	RA.recipient_rank = recipient_rank
	RA.medal_names += medal_type
	RA.medal_citations += citation
	RA.posthumous += posthumous

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
			else return
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
