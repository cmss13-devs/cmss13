
var/global/list/medal_awards = list()


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
	for(var/datum/data/record/t in data_core.general)
		var/rcpt_name = t.fields["name"]
		listed_rcpt_ranks[rcpt_name] = t.fields["rank"]
		possible_recipients += rcpt_name
	var/chosen_recipient = input("Who do you want to award a medal to?", "Medal Recipient", "Cancel") in possible_recipients
	if(!chosen_recipient || chosen_recipient == "Cancel") return
	var/recipient_rank = listed_rcpt_ranks[chosen_recipient]
	var/posthumous = 1
	var/medal_type = input("What type of medal do you want to award?", "Medal Type", null) in list("distinguished conduct medal", "bronze heart medal","medal of valor", "medal of exceptional heroism")
	if(!medal_type) return
	var/citation = strip_html(input("What should the medal citation read?","Medal Citation", null) as text|null, MAX_PAPER_MESSAGE_LEN)
	if(!citation) return
	var/recipient_ckey
	for(var/mob/M in mob_list)
		if(M == usr)
			M.count_niche_stat(STATISTICS_NICHE_MEDALS_GIVE)
		if(M.real_name == chosen_recipient)
			if(isliving(M) && M.stat != DEAD)
				posthumous = 0
			if(M.mind)
				recipient_ckey = M.mind.ckey
			break
	if(!medal_awards[chosen_recipient])
		medal_awards[chosen_recipient] = new /datum/recipient_awards()
	var/datum/recipient_awards/RA = medal_awards[chosen_recipient]
	RA.recipient_rank = recipient_rank
	RA.medal_names += medal_type
	RA.medal_citations += citation
	RA.posthumous += posthumous

	if(recipient_ckey)
		var/datum/entity/player_entity/P = setup_player_entity(recipient_ckey)
		if(P)
			P.track_medal_earned(medal_type, chosen_recipient, recipient_rank, citation)

	if(medal_location)
		var/obj/item/clothing/accessory/medal/MD
		switch(medal_type)
			if("distinguished conduct medal")	MD = new /obj/item/clothing/accessory/medal/conduct(medal_location)
			if("bronze heart medal") 			MD = new /obj/item/clothing/accessory/medal/bronze_heart(medal_location)
			if("medal of valor") 				MD = new /obj/item/clothing/accessory/medal/silver/valor(medal_location)
			if("medal of exceptional heroism")	MD = new /obj/item/clothing/accessory/medal/gold/heroism(medal_location)
			else return
		MD.recipient_name = chosen_recipient
		MD.medal_citation = citation
		MD.recipient_rank = recipient_rank
	message_admins("[key_name_admin(usr)] awarded a [medal_type] to [chosen_recipient] for: \'[citation]\'.")

	return TRUE
