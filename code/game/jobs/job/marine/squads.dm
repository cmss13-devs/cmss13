//This datum keeps track of individual squads. New squads can be added without any problem but to give them
//access you must add them individually to access.dm with the other squads. Just look for "access_alpha" and add the new one

//Note: some important procs are held by the job controller, in job_controller.dm.
//In particular, get_lowest_squad() and randomize_squad()
/datum/squad_type //Majority of this is for a follow-on PR to fully flesh the system out and add more bits for other factions.
	var/name = "Squad Type"
	var/lead_name
	var/lead_icon
	var/sub_squad
	var/sub_leader

/datum/squad_type/marine_squad
	name = "Squad"
	lead_name = "Squad Leader"
	lead_icon = "leader"
	sub_squad = "Fireteam"
	sub_leader = "Fireteam Leader"

/datum/squad_type/marsoc_team
	name = "Team"
	lead_name = "Team Leader"
	lead_icon = "soctl"
	sub_squad = "Strike Team"
	sub_leader = "Strike Leader"

/datum/squad
	var/name //Name of the squad
	var/tracking_id = null //Used for the tracking subsystem
	var/max_positions = -1 //Maximum number allowed in a squad. Defaults to infinite
	var/color = 0 //Color for helmets, etc.
	var/list/access = list() //Which special access do we grant them
	var/omni_squad_vendor = FALSE /// Can use any squad vendor regardless of squad connection
	var/max_engineers = 3 //maximum # of engineers allowed in squad
	var/max_medics = 4 //Ditto, squad medics
	var/max_specialists = 1
	var/max_rto = 2
	var/max_smartgun = 1
	var/max_leaders = 1
	var/radio_freq = 1461 //Squad radio headset frequency.

	///Variables for showing up in various places
	var/usable = FALSE  //Is it used in-game?
	var/roundstart = TRUE /// Whether this squad can be picked at roundstart
	var/locked = FALSE //Is it available for squad management?
	var/active = FALSE //Is it visible in overwatch?
	var/faction = FACTION_MARINE //What faction runs the squad?

	///Squad Type Specifics
	var/squad_type = "Squad" //Referenced for aSL details. Squad/Team/Cell etc.
	var/lead_icon //Referenced for SL's 'L' icon. If nulled, won't override icon for aSLs.

	//vvv Do not set these in squad defines
	var/mob/living/carbon/human/squad_leader = null //Who currently leads it.
	var/list/fireteam_leaders = list(
									"FT1" = null,
									"FT2" = null,
									"FT3" = null
									) //FT leaders stored here
	var/list/list/fireteams = list(
							"FT1" = list(),
							"FT2" = list(),
							"FT3" = list()
							) //3 FTs where references to marines stored.
	var/list/squad_info_data = list()

	var/num_engineers = 0
	var/num_medics = 0
	var/num_leaders = 0
	var/num_smartgun = 0
	var/num_specialists = 0
	var/num_rto = 0
	var/count = 0 //Current # in the squad
	var/list/marines_list = list() // list of mobs (or name, not always a mob ref) in that squad.

	var/mob/living/carbon/human/overwatch_officer = null //Who's overwatching this squad?
	COOLDOWN_DECLARE(next_supplydrop)

	///Text strings, not HTML safe so don't use it without encoding
	var/primary_objective = null
	var/secondary_objective = null

	var/obj/item/device/squad_beacon/sbeacon = null
	var/obj/item/device/squad_beacon/bomb/bbeacon = null
	var/obj/structure/supply_drop/drop_pad = null

	var/minimap_color = MINIMAP_SQUAD_UNKNOWN


/datum/squad/marine
	name = "Root"
	usable = TRUE
	active = TRUE
	faction = FACTION_MARINE
	lead_icon = "leader"

/datum/squad/marine/alpha
	name = SQUAD_MARINE_1
	color = 1
	access = list(ACCESS_MARINE_ALPHA)
	radio_freq = ALPHA_FREQ
	minimap_color = MINIMAP_SQUAD_ALPHA

/datum/squad/marine/bravo
	name = SQUAD_MARINE_2
	color = 2
	access = list(ACCESS_MARINE_BRAVO)
	radio_freq = BRAVO_FREQ
	minimap_color = MINIMAP_SQUAD_BRAVO

/datum/squad/marine/charlie
	name = SQUAD_MARINE_3
	color = 3
	access = list(ACCESS_MARINE_CHARLIE)
	radio_freq = CHARLIE_FREQ
	minimap_color = MINIMAP_SQUAD_CHARLIE

/datum/squad/marine/delta
	name = SQUAD_MARINE_4
	color = 4
	access = list(ACCESS_MARINE_DELTA)
	radio_freq = DELTA_FREQ
	minimap_color = MINIMAP_SQUAD_DELTA

/datum/squad/marine/echo
	name = SQUAD_MARINE_5
	color = 5
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	radio_freq = ECHO_FREQ
	omni_squad_vendor = TRUE
	minimap_color = MINIMAP_SQUAD_ECHO

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/cryo
	name = SQUAD_MARINE_CRYO
	color = 6
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	minimap_color = MINIMAP_SQUAD_FOXTROT

	omni_squad_vendor = TRUE
	radio_freq = CRYO_FREQ

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/sof
	name = SQUAD_SOF
	color = 7
	radio_freq = SOF_FREQ
	squad_type = "Team"
	lead_icon = "soctl"
	minimap_color = MINIMAP_SQUAD_SOF

	active = FALSE
	roundstart = FALSE
	locked = TRUE

//############################### UPP Squads
/datum/squad/upp
	name = "Root"
	usable = TRUE
	omni_squad_vendor = TRUE
	faction = FACTION_UPP

/datum/squad/upp/one
	name = "UPPS1"
	color = 1

/datum/squad/upp/twp
	name = "UPPS2"
	color = 2

/datum/squad/upp/three
	name = "UPPS3"
	color = 3

/datum/squad/upp/four
	name = "UPPS4"
	color = 4

/datum/squad/upp/kdo
	name = "UPPKdo"
	color = 6
	squad_type = "Team"
	locked = TRUE
//###############################
/datum/squad/pmc
	name = "Root"
	squad_type = "Team"
	faction = FACTION_PMC
	usable = TRUE
	omni_squad_vendor = TRUE

/datum/squad/pmc/one
	name = "Team Upsilon"
	color = 3

/datum/squad/pmc/two
	name = "Team Gamma"
	color = 6

/datum/squad/pmc/wo
	name = "Taskforce White"
	locked = TRUE
	faction = FACTION_WY_DEATHSQUAD
//###############################
/datum/squad/clf
	name = "Root"
	squad_type = "Cell"
	faction = FACTION_CLF
	usable = TRUE
	omni_squad_vendor = TRUE

/datum/squad/clf/one
	name = "Python"

/datum/squad/clf/two
	name = "Viper"

/datum/squad/clf/three
	name = "Cobra"

/datum/squad/clf/four
	name = "Boa"
//###############################
/datum/squad/New()
	. = ..()

	tracking_id = SStracking.setup_trackers()
	SStracking.setup_trackers(null, "FT1")
	SStracking.setup_trackers(null, "FT2")
	SStracking.setup_trackers(null, "FT3")
	update_all_squad_info()

	RegisterSignal(SSdcs, COMSIG_GLOB_MODE_POSTSETUP, PROC_REF(setup_supply_drop_list))

/datum/squad/proc/setup_supply_drop_list()
	SIGNAL_HANDLER

	for(var/i in GLOB.supply_drop_list)
		var/obj/structure/supply_drop/supply = i
		if(name == supply.squad)
			drop_pad = supply
			break

/// Sets an overwatch officer for the squad, returning TRUE on success
/datum/squad/proc/assume_overwatch(mob/current_mob)
	var/mob/previous
	if(overwatch_officer)
		if(overwatch_officer == current_mob)
			return FALSE
		previous = overwatch_officer
		overwatch_officer = null
		clear_ref_tracking(previous)
	overwatch_officer = current_mob
	RegisterSignal(overwatch_officer, COMSIG_PARENT_QDELETING, PROC_REF(personnel_deleted), override = TRUE)
	return TRUE

/// Explicitely relinquish overwatch control
/datum/squad/proc/release_overwatch()
	if(!overwatch_officer)
		return FALSE
	var/mob/operator = overwatch_officer
	overwatch_officer = null
	clear_ref_tracking(operator)
	return TRUE

/// Clear deletion signal as needed for mob - to call *after* removal
/datum/squad/proc/clear_ref_tracking(mob/current_mob)
	if(!current_mob) return FALSE
	if(current_mob in marines_list)
		return FALSE
	if(overwatch_officer == current_mob)
		return FALSE
	UnregisterSignal(current_mob, COMSIG_PARENT_QDELETING)
	return TRUE

/// Clear references in squad listing upon deletion. Zap also erases the kept records.
/datum/squad/proc/personnel_deleted(mob/current_mob, zap = FALSE)
	SIGNAL_HANDLER
	if(current_mob == overwatch_officer)
		overwatch_officer = null
	if(current_mob == squad_leader)
		squad_leader = null
	SStracking.stop_tracking(tracking_id, current_mob)
	if(zap)
		marines_list.Remove(current_mob)
		return
	var/idx = marines_list.Find(current_mob)
	if(idx)
		marines_list[idx] = current_mob.name // legacy behavior, replace mob ref index by name. very weird

/*
 * Send a text message to the squad members following legacy overwatch usage
 *
 * input_text: raw user input as text
 * user: mob reference to whoever the message is sent on behalf of - adds sounds notification
 * displayed_icon: /atom or /icon to display by the message in chat
 * leader_only: if truthy sends only to the squad leader
 */
/datum/squad/proc/send_squad_message(input_text, mob/user, displayed_icon, leader_only = FALSE)
	var/message = sanitize_control_chars(strip_html(input_text))
	var/datum/sound_template/sfx

	if(user)
		message = "[user.name] transmits: [FONT_SIZE_LARGE("<b>[message]<b>")]"
		sfx = new()
		sfx.file = 'sound/effects/radiostatic.ogg'
		sfx.channel = get_free_channel()
		sfx.y = 3
	message = "[SPAN_BLUE("<B>[leader_only ? "SL " : ""]Overwatch:</b> [message]")]"

	var/list/client/targets = list()
	if(leader_only)
		targets = list(squad_leader)
	else
		for(var/mob/current_mob in marines_list)
			if(!current_mob.stat && current_mob.client)
				targets += current_mob.client

	if(displayed_icon)
		message = "[icon2html(displayed_icon, targets, dir = null)] [message]"
	if(sfx)
		SSsound.queue(sfx, targets)
	to_chat(targets, html = message, type = MESSAGE_TYPE_RADIO)

/// Displays a message to squad members directly on the game map
/datum/squad/proc/send_maptext(text = "", title_text = "", only_leader = 0)
	var/message_colour = squad_colors_chat[color]
	if(only_leader)
		if(squad_leader)
			var/mob/living/carbon/human/SL = squad_leader
			if(!SL.stat && SL.client)
				SL.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, message_colour)
	else
		for(var/mob/living/carbon/human/current_mob in marines_list)
			if(!current_mob.stat && current_mob.client) //Only living and connected people in our squad
				current_mob.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, message_colour)

/// Displays a message to the squad members in chat
/datum/squad/proc/send_message(text = "", plus_name = 0, only_leader = 0)
	var/nametext = ""
	if(plus_name)
		nametext = "[usr.name] transmits: "
		text = "[FONT_SIZE_LARGE("<b>[text]<b>")]"

	if(only_leader)
		if(squad_leader)
			var/mob/living/carbon/human/SL = squad_leader
			if(!SL.stat && SL.client)
				if(plus_name)
					SL << sound('sound/effects/tech_notification.ogg')
				to_chat(SL, "[SPAN_BLUE("<B>SL Overwatch:</b> [nametext][text]")]")
				return
	else
		for(var/mob/living/carbon/human/current_mob in marines_list)
			if(!current_mob.stat && current_mob.client) //Only living and connected people in our squad
				if(plus_name)
					current_mob << sound('sound/effects/tech_notification.ogg')
				to_chat(current_mob, "[SPAN_BLUE("<B>Overwatch:</b> [nametext][text]")]")



//Straight-up insert a marine into a squad.
//This sets their ID, increments the total count, and so on. Everything else is done in job_controller.dm.
//So it does not check if the squad is too full already, or randomize it, etc.
/datum/squad/proc/put_marine_in_squad(mob/living/carbon/human/current_mob, obj/item/card/id/ID)

	if(!istype(current_mob))
		return FALSE //Logic
	if(!src.usable)
		return FALSE
	if(!current_mob.job)
		return FALSE //Not yet
	if(current_mob.assigned_squad)
		return FALSE //already in a squad

	var/obj/item/card/id/card = ID
	if(!card)
		card = current_mob.wear_id
	if(!card)
		card = current_mob.get_active_hand()
	if(!istype(card))
		return FALSE //No ID found

	var/assignment = current_mob.job
	var/paygrade

	var/list/extra_access = list()

	switch(GET_DEFAULT_ROLE(current_mob.job))
		if(JOB_SQUAD_ENGI)
			assignment = JOB_SQUAD_ENGI
			num_engineers++
			card.claimedgear = FALSE
		if(JOB_SQUAD_MEDIC)
			assignment = JOB_SQUAD_MEDIC
			num_medics++
			card.claimedgear = FALSE
		if(JOB_SQUAD_SPECIALIST)
			assignment = JOB_SQUAD_SPECIALIST
			num_specialists++
		if(JOB_SQUAD_RTO)
			assignment = JOB_SQUAD_RTO
			num_rto++
			current_mob.important_radio_channels += radio_freq
		if(JOB_SQUAD_SMARTGUN)
			assignment = JOB_SQUAD_SMARTGUN
			num_smartgun++
		if(JOB_SQUAD_LEADER)
			if(squad_leader && GET_DEFAULT_ROLE(squad_leader.job) != JOB_SQUAD_LEADER) //field promoted SL
				var/old_lead = squad_leader
				demote_squad_leader() //replaced by the real one
				SStracking.start_tracking(tracking_id, old_lead)
			assignment = squad_type + " Leader"
			squad_leader = current_mob
			SStracking.set_leader(tracking_id, current_mob)
			SStracking.start_tracking("marine_sl", current_mob)

			if(GET_DEFAULT_ROLE(current_mob.job) == JOB_SQUAD_LEADER) //field promoted SL don't count as real ones
				num_leaders++

		if(JOB_MARINE_RAIDER)
			assignment = JOB_MARINE_RAIDER
			if(name == JOB_MARINE_RAIDER)
				assignment = "Special Operator"
		if(JOB_MARINE_RAIDER_SL)
			assignment = JOB_MARINE_RAIDER_SL
			if(name == JOB_MARINE_RAIDER)
				if(squad_leader && GET_DEFAULT_ROLE(squad_leader.job) != JOB_MARINE_RAIDER_SL) //field promoted SL
					var/old_lead = squad_leader
					demote_squad_leader() //replaced by the real one
					SStracking.start_tracking(tracking_id, old_lead)
				assignment = squad_type + " Leader"
				squad_leader = current_mob
				SStracking.set_leader(tracking_id, current_mob)
				SStracking.start_tracking("marine_sl", current_mob)
				if(GET_DEFAULT_ROLE(current_mob.job) == JOB_MARINE_RAIDER_SL) //field promoted SL don't count as real ones
					num_leaders++
		if(JOB_MARINE_RAIDER_CMD)
			assignment = JOB_MARINE_RAIDER_CMD
			if(name == JOB_MARINE_RAIDER)
				assignment = "Officer"

	RegisterSignal(current_mob, COMSIG_PARENT_QDELETING, PROC_REF(personnel_deleted), override = TRUE)
	if(assignment != JOB_SQUAD_LEADER)
		SStracking.start_tracking(tracking_id, current_mob)

	count++ //Add up the tally. This is important in even squad distribution.

	if(GET_DEFAULT_ROLE(current_mob.job) != JOB_SQUAD_MARINE)
		log_admin("[key_name(current_mob)] has been assigned as [name] [current_mob.job]") // we don't want to spam squad marines but the others are useful

	marines_list += current_mob
	current_mob.assigned_squad = src //Add them to the squad
	card.access += (src.access + extra_access) //Add their squad access to their ID
	card.assignment = "[name] [assignment]"

	SEND_SIGNAL(current_mob, COMSIG_SET_SQUAD)

	if(paygrade)
		card.paygrade = paygrade
	card.name = "[card.registered_name]'s ID Card ([card.assignment])"

	var/obj/item/device/radio/headset/almayer/marine/headset = locate() in list(current_mob.wear_l_ear, current_mob.wear_r_ear)
	if(headset)
		headset.set_frequency(radio_freq)
	current_mob.update_inv_head()
	current_mob.update_inv_wear_suit()
	current_mob.update_inv_gloves()
	return TRUE

//proc used by the overwatch console to transfer marine to another squad
/datum/squad/proc/remove_marine_from_squad(mob/living/carbon/human/current_mob, obj/item/card/id/ID)
	if(current_mob.assigned_squad != src)
		return //not assigned to the correct squad
	var/obj/item/card/id/card = ID
	if(!istype(card))
		card = current_mob.wear_id
	if(!istype(card))
		return FALSE //Abort, no ID found

	card.access -= src.access
	card.assignment = current_mob.job
	card.name = "[card.registered_name]'s ID Card ([card.assignment])"

	forget_marine_in_squad(current_mob)

//gracefully remove a marine from squad system, alive, dead or otherwise
/datum/squad/proc/forget_marine_in_squad(mob/living/carbon/human/current_mob)
	if(current_mob.assigned_squad.squad_leader == current_mob)
		if(GET_DEFAULT_ROLE(current_mob.job) != JOB_SQUAD_LEADER) //a field promoted SL, not a real one
			demote_squad_leader()
		else
			current_mob.assigned_squad.squad_leader = null
		update_squad_leader()
	else
		if(current_mob.assigned_fireteam)
			if(fireteam_leaders[current_mob.assigned_fireteam] == current_mob)
				unassign_ft_leader(current_mob.assigned_fireteam, TRUE, FALSE)
			unassign_fireteam(current_mob, FALSE)

	count--
	marines_list -= current_mob
	personnel_deleted(current_mob, zap = TRUE) // Free all refs and Zap it entierly as this is on purpose
	clear_ref_tracking(current_mob)
	update_free_mar()
	current_mob.assigned_squad = null

	switch(GET_DEFAULT_ROLE(current_mob.job))
		if(JOB_SQUAD_ENGI)
			num_engineers--
		if(JOB_SQUAD_MEDIC)
			num_medics--
		if(JOB_SQUAD_SPECIALIST)
			num_specialists--
		if(JOB_SQUAD_SMARTGUN)
			num_smartgun--
		if(JOB_SQUAD_RTO)
			num_rto--
		if(JOB_SQUAD_LEADER)
			num_leaders--

//proc for demoting current Squad Leader
/datum/squad/proc/demote_squad_leader(leader_killed)
	var/mob/living/carbon/human/old_lead = squad_leader

	SStracking.delete_leader(tracking_id)
	SStracking.stop_tracking("marine_sl", old_lead)

	squad_leader = null
	switch(GET_DEFAULT_ROLE(old_lead.job))
		if(JOB_SQUAD_SPECIALIST)
			old_lead.comm_title = "Spc"
		if(JOB_SQUAD_ENGI)
			old_lead.comm_title = "ComTech"
		if(JOB_SQUAD_MEDIC)
			old_lead.comm_title = "HM"
		if(JOB_SQUAD_RTO)
			old_lead.comm_title = "RTO"
		if(JOB_SQUAD_SMARTGUN)
			old_lead.comm_title = "SG"
		if(JOB_SQUAD_LEADER)
			if(!leader_killed)
				old_lead.comm_title = "Sgt"
		if(JOB_MARINE_RAIDER)
			old_lead.comm_title = "Op."
		if(JOB_MARINE_RAIDER_SL)
			old_lead.comm_title = "TL."
		if(JOB_MARINE_RAIDER_CMD)
			old_lead.comm_title = "CMD."
		else
			old_lead.comm_title = "RFN"

	if(GET_DEFAULT_ROLE(old_lead.job) != JOB_SQUAD_LEADER || !leader_killed)
		var/obj/item/device/radio/headset/almayer/marine/new_leader = old_lead.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
		if(new_leader)
			for(var/obj/item/device/encryptionkey/squadlead/acting/key in new_leader.keys)
				new_leader.keys -= key
				qdel(key)
			new_leader.recalculateChannels()
		if(istype(old_lead.wear_id, /obj/item/card/id))
			var/obj/item/card/id/ID = old_lead.wear_id
			ID.access -= ACCESS_MARINE_LEADER
	REMOVE_TRAITS_IN(old_lead, TRAIT_SOURCE_SQUAD_LEADER)
	old_lead.hud_set_squad()
	old_lead.update_inv_head() //updating marine helmet leader overlays
	old_lead.update_inv_wear_suit()
	to_chat(old_lead, FONT_SIZE_BIG(SPAN_BLUE("You're no longer the [squad_type] Leader for [src]!")))

//Not a safe proc. Returns null if squads or jobs aren't set up.
//Mostly used in the marine squad console in marine_consoles.dm.
/proc/get_squad_by_name(text)
	if(!RoleAuthority || RoleAuthority.squads.len == 0)
		return null
	var/datum/squad/current_squad
	for(current_squad in RoleAuthority.squads)
		if(current_squad.name == text)
			return current_squad
	return null

/datum/squad/proc/engage_squad(toggle_lock = FALSE)
	active = TRUE//Shows up in Overwatch
	usable = TRUE//Shows up in most backend checks
	if(toggle_lock)//Allows adding new marines
		locked = FALSE

/datum/squad/proc/lock_squad(toggle_lock = FALSE)
	active = FALSE
	usable = FALSE
	if(toggle_lock)
		locked = TRUE


//below are procs used by acting SL to organize their squad
/datum/squad/proc/assign_fireteam(fireteam, mob/living/carbon/human/human, upd_ui = TRUE)
	if(human.assigned_fireteam)
		if(fireteam_leaders[human.assigned_fireteam])
			if(fireteam_leaders[human.assigned_fireteam] == human)
				unassign_ft_leader(human.assigned_fireteam, TRUE) //remove marine from TL position
			else
				SStracking.stop_tracking(human.assigned_fireteam, human) //remove from previous FT group
				if(human.stat == CONSCIOUS)
					to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[human.mind ? human.comm_title : ""] [human] was unassigned from your fireteam.")))
		fireteams[human.assigned_fireteam].Remove(human)
		var/ft = human.assigned_fireteam
		human.assigned_fireteam = fireteam
		fireteams[fireteam].Add(human) //adding to fireteam
		update_fireteam(ft)
		update_fireteam(fireteam)
		if(fireteam_leaders[fireteam]) //if TL exists -> FT group, otherwise -> SL group
			SStracking.start_tracking(fireteam, human)
			if(human.stat == CONSCIOUS)
				to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Fireteam Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[human.mind ? human.comm_title : ""] [human] was assigned to your fireteam.")))
		else
			SStracking.start_tracking(tracking_id, human)
			if(human.stat == CONSCIOUS)
				to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	else
		fireteams[fireteam].Add(human)
		human.assigned_fireteam = fireteam //adding to fireteam
		update_fireteam(fireteam)
		update_free_mar()
		if(fireteam_leaders[fireteam])
			SStracking.stop_tracking(tracking_id, human) //remove from previous FT group
			SStracking.start_tracking(fireteam, human)
			if(human.stat == CONSCIOUS)
				to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Fireteam Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[human.mind ? human.comm_title : ""] [human] was assigned to your fireteam.")))
		if(human.stat == CONSCIOUS)
			to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	human.hud_set_squad()

/datum/squad/proc/unassign_fireteam(mob/living/carbon/human/human, upd_ui = TRUE)
	fireteams[human.assigned_fireteam].Remove(human)
	var/ft = human.assigned_fireteam
	human.assigned_fireteam = 0
	update_fireteam(ft)
	update_free_mar()
	if(fireteam_leaders[ft])
		SStracking.stop_tracking(ft, human) //remove from FT group
		SStracking.start_tracking(tracking_id, human) //add to SL group
		to_chat(fireteam_leaders[ft], FONT_SIZE_HUGE(SPAN_BLUE("[human.mind ? human.comm_title : ""] [human] was unassigned from your fireteam.")))
	if(!human.stat)
		to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned from [ft].")))
	human.hud_set_squad()

/datum/squad/proc/assign_ft_leader(fireteam, mob/living/carbon/human/human, upd_ui = TRUE)
	if(fireteam_leaders[fireteam])
		unassign_ft_leader(fireteam, FALSE, FALSE)
	fireteam_leaders[fireteam] = human
	human.hud_set_squad()
	update_fireteam(fireteam)
	SStracking.set_leader(human.assigned_fireteam, human) //Set FT leader as leader of this group
	SStracking.start_tracking("marine_sl", human)
	if(human.stat == CONSCIOUS)
		to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_ft_leader(fireteam, clear_group_id, upd_ui = TRUE)
	if(!fireteam_leaders[fireteam])
		return
	var/mob/living/carbon/human/human = fireteam_leaders[fireteam]
	fireteam_leaders[fireteam] = null
	human.hud_set_squad()
	if(clear_group_id)
		reassign_ft_tracker_group(fireteam, human.assigned_fireteam, tracking_id) //transfer whole FT to SL group
		update_fireteam(fireteam)
	if(!human.stat)
		to_chat(human, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_all_ft_leaders()
	for(var/team in fireteam_leaders)
		if(fireteam_leaders[team])
			unassign_ft_leader(team, TRUE, TRUE)

/datum/squad/proc/reassign_ft_tracker_group(fireteam, old_id, new_id)
	for(var/mob/living/carbon/human/human in fireteams[fireteam])
		SStracking.stop_tracking(old_id, human)
		SStracking.start_tracking(new_id, human)

//moved the main proc for ft management from human.dm here to make it support both examine and squad info way to edit fts
/datum/squad/proc/manage_fireteams(mob/living/carbon/human/target)
	var/obj/item/card/id/ID = target.get_idcard()
	if(!ID || !(ID.rank in ROLES_MARINES))
		return
	if(ID.rank == JOB_SQUAD_LEADER || squad_leader == target) //if SL/aSL are chosen
		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign Fireteam 1 Leader", "Unassign Fireteam 2 Leader", "Unassign Fireteam 3 Leader", "Unassign all Team Leaders"))
		if(target.assigned_squad != src)
			return //in case they somehow change squad while SL is choosing
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return //if SL got knocked out or demoted while choosing
		switch(choice)
			if("Unassign Fireteam 1 Leader") unassign_ft_leader("FT1", TRUE)
			if("Unassign Fireteam 2 Leader") unassign_ft_leader("FT2", TRUE)
			if("Unassign Fireteam 3 Leader") unassign_ft_leader("FT3", TRUE)
			if("Unassign all Team Leaders") unassign_all_ft_leaders()
			else return
		target.hud_set_squad()
		return
	if(target.assigned_fireteam)
		if(fireteam_leaders[target.assigned_fireteam] == target) //Check if person already is FT leader
			var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign from Team Leader position"))
			if(target.assigned_squad != src)
				return
			if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
				return
			if(choice == "Unassign from Team Leader position")
				unassign_ft_leader(target.assigned_fireteam, TRUE)
			target.hud_set_squad()
			return

		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Remove from Fireteam", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3", "Assign as Team Leader"))
		if(target.assigned_squad != src)
			return
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return
		switch(choice)
			if("Remove from Fireteam") unassign_fireteam(target)
			if("Assign to Fireteam 1") assign_fireteam("FT1", target)
			if("Assign to Fireteam 2") assign_fireteam("FT2", target)
			if("Assign to Fireteam 3") assign_fireteam("FT3", target)
			if("Assign as Team Leader") assign_ft_leader(target.assigned_fireteam, target)
			else return
		target.hud_set_squad()
		return

	var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3"))
	if(target.assigned_squad != src)
		return
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return
	switch(choice)
		if("Assign to Fireteam 1") assign_fireteam("FT1", target)
		if("Assign to Fireteam 2") assign_fireteam("FT2", target)
		if("Assign to Fireteam 3") assign_fireteam("FT3", target)
		else return
	target.hud_set_squad()
	return

//Managing MIA and KIA statuses for marines
/datum/squad/proc/change_squad_status(mob/living/carbon/human/target)
	if(target == squad_leader)
		return //you can't mark yourself KIA
	var/choice = tgui_input_list(squad_leader, "Marine status management: M.I.A. for missing marines, K.I.A. for confirmed unrevivable dead.", "Squad Management", list("Cancel", "Remove status", "M.I.A.", "K.I.A."))
	if(target.assigned_squad != src)
		return //in case they somehow change squad while SL is choosing
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return //if SL got knocked out or demoted while choosing
	switch(choice)
		if("Remove status") target.squad_status = null
		if("M.I.A.")
			target.squad_status = choice
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target]'s status as Missing In Action.")))
			if(target.stat == CONSCIOUS)
				to_chat(target, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Missing In Action by Squad Leader.")))
		if("K.I.A.")
			target.squad_status = choice
			if(target.assigned_fireteam)
				if(fireteam_leaders[target.assigned_fireteam] == target)
					unassign_ft_leader(target.assigned_fireteam, TRUE, FALSE)
				unassign_fireteam(target, FALSE)
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target]'s status as Killed In Action. If they were Team Leader or in fireteam, they were demoted and unassigned.")))
			if(target.stat == CONSCIOUS)
				to_chat(target, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Killed In Action by Squad Leader.")))
		else return
	if(target.assigned_fireteam)
		update_fireteam(target.assigned_fireteam)
	else
		update_free_mar()
	target.hud_set_squad()
	return
