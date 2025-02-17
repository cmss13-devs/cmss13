//This datum keeps track of individual squads. New squads can be added without any problem but to give them
//access you must add them individually to access.dm with the other squads. Just look for "access_alpha" and add the new one

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
	/// Name of the squad
	var/name
	/// Equivalent name so that lobby prefered squad gets used for other factions
	var/equivalent_name
	/// Squads ID that is set on New()
	var/tracking_id = null //Used for the tracking subsystem
	/// Maximum number allowed in a squad. Defaults to infinite
	var/max_positions = -1
	/// If uses the overlay
	var/use_stripe_overlay = TRUE
	/// Color for the squad marines gear overlays
	var/equipment_color = COLOR_WHITE
	/// The alpha for the armor overlay used by equipment color
	var/armor_alpha = 125
	/// Color for the squad marines langchat
	var/chat_color = COLOR_WHITE
	/// Which special access do we grant them
	var/list/access = list()
	/// Can use any squad vendor regardless of squad connection
	var/omni_squad_vendor = FALSE
	/// Squad roles max caps per role list
	var/list/roles_cap = list(
		JOB_SQUAD_MARINE = null,
		JOB_SQUAD_ENGI = 3,
		JOB_SQUAD_MEDIC = 4,
		JOB_SQUAD_SMARTGUN = 1,
		JOB_SQUAD_SPECIALIST = 1,
		JOB_SQUAD_TEAM_LEADER = 2,
		JOB_SQUAD_LEADER = 1,
	)
	/// Squad roles actual number of players list
	var/list/roles_in = list()
	/// Squad headsets default radio frequency
	var/radio_freq = 1461
	/// Whether this squad can be used by marines
	var/usable = FALSE
	/// Whether this squad can be picked at roundstart
	var/roundstart = TRUE
	// Whether the squad is available for squad management
	var/locked = FALSE
	/// Whether it is visible in overwatch
	var/active = TRUE //this var in fact looks COMPLEATLY useless as visibility in overwatch is also determined by faction
	/// Which faction the squad is in
	var/faction = FACTION_MARINE

	/// What will the assistant squad leader be called
	var/squad_type = "Squad" //Referenced for aSL details. Squad/Team/Cell etc.
	/// Squad leaders icon
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

	///Icon for the background of minimap icon
	var/background_icon = "background"

	///Should we add the name of our squad in front of their name? Ex: Alpha Hospital Corpsman
	var/prepend_squad_name_to_assignment = TRUE



/datum/squad/marine
	name = "Root"
	usable = TRUE
	active = TRUE
	faction = FACTION_MARINE
	lead_icon = "leader"

/datum/squad/marine/alpha
	name = SQUAD_MARINE_1
	equipment_color = "#e61919"
	chat_color = "#e67d7d"
	access = list(ACCESS_MARINE_ALPHA)
	radio_freq = ALPHA_FREQ
	minimap_color = MINIMAP_SQUAD_ALPHA
	background_icon = "background_alpha"

/datum/squad/marine/bravo
	name = SQUAD_MARINE_2
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	access = list(ACCESS_MARINE_BRAVO)
	radio_freq = BRAVO_FREQ
	minimap_color = MINIMAP_SQUAD_BRAVO
	background_icon = "background_bravo"

/datum/squad/marine/charlie
	name = SQUAD_MARINE_3
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	access = list(ACCESS_MARINE_CHARLIE)
	radio_freq = CHARLIE_FREQ
	minimap_color = MINIMAP_SQUAD_CHARLIE
	background_icon = "background_charlie"

/datum/squad/marine/delta
	name = SQUAD_MARINE_4
	equipment_color = "#4148c8"
	chat_color = "#828cff"
	access = list(ACCESS_MARINE_DELTA)
	radio_freq = DELTA_FREQ
	minimap_color = MINIMAP_SQUAD_DELTA
	background_icon = "background_delta"

/datum/squad/marine/echo
	name = SQUAD_MARINE_5
	equipment_color = "#67d692"
	chat_color = "#67d692"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	radio_freq = ECHO_FREQ
	omni_squad_vendor = TRUE
	minimap_color = MINIMAP_SQUAD_ECHO
	background_icon = "background_echo"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/cryo
	name = SQUAD_MARINE_CRYO
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	minimap_color = MINIMAP_SQUAD_FOXTROT
	background_icon = "background_foxtrot"

	omni_squad_vendor = TRUE
	radio_freq = CRYO_FREQ

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/intel
	name = SQUAD_MARINE_INTEL
	use_stripe_overlay = FALSE
	equipment_color = "#053818"
	minimap_color = MINIMAP_SQUAD_INTEL
	radio_freq = INTEL_FREQ
	background_icon = "background_intel"

	roundstart = FALSE
	prepend_squad_name_to_assignment = FALSE

	roles_cap = list(
		JOB_SQUAD_MARINE = null,
		JOB_SQUAD_ENGI = 0,
		JOB_SQUAD_MEDIC = 0,
		JOB_SQUAD_SMARTGUN = 0,
		JOB_SQUAD_SPECIALIST = 0,
		JOB_SQUAD_TEAM_LEADER = 0,
		JOB_SQUAD_LEADER = 0,
	)

/datum/squad/marine/sof
	name = SQUAD_SOF
	equipment_color = "#400000"
	chat_color = "#400000"
	radio_freq = SOF_FREQ
	squad_type = "Team"
	lead_icon = "soctl"
	minimap_color = MINIMAP_SQUAD_SOF
	background_icon = "background_sof"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/cbrn
	name = SQUAD_CBRN
	equipment_color = "#3B2A7B" //Chemical Corps Purple
	chat_color = "#553EB2"
	radio_freq = CBRN_FREQ
	minimap_color = "#3B2A7B"
	background_icon = "background_cbrn"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/forecon
	name = SQUAD_FORECON
	equipment_color = "#32CD32"
	chat_color = "#32CD32"
	radio_freq = FORECON_FREQ
	minimap_color = "#32CD32"
	background_icon = "background_forecon"

	active = FALSE
	roundstart = FALSE
	locked = TRUE

/datum/squad/marine/solardevils
	name = SQUAD_SOLAR
	equipment_color = "#5a2c2c"
	chat_color = "#5a2c2c"
	radio_freq = SOF_FREQ
	minimap_color = "#5a2c2c"
	background_icon = "background_civillian"

	active = FALSE
	roundstart = FALSE
	locked = TRUE


//############################### UPP Squads
/datum/squad/upp
	name = "Root"
	usable = TRUE
	omni_squad_vendor = TRUE
	faction = FACTION_UPP
	radio_freq = UPP_FREQ
	roles_cap = list(
		JOB_UPP_ENGI = 3,
		JOB_UPP_MEDIC = 4,
		JOB_UPP_SPECIALIST = 1,
		JOB_UPP_LEADER = 1,
	)

/datum/squad/upp/one
	name = SQUAD_UPP_1
	equivalent_name = SQUAD_MARINE_1
	equipment_color = "#e61919"
	chat_color = "#e67d7d"
	background_icon = "background_upp_alpha"

/datum/squad/upp/two
	name = SQUAD_UPP_2
	equivalent_name = SQUAD_MARINE_2
	equipment_color = "#ffc32d"
	chat_color = "#ffe650"
	background_icon = "background_upp_bravo"

/datum/squad/upp/three
	name = SQUAD_UPP_3
	equivalent_name = SQUAD_MARINE_3
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"
	background_icon = "background_upp_charlie"

/datum/squad/upp/four
	name = SQUAD_UPP_4
	equivalent_name = SQUAD_MARINE_4
	equipment_color = "#4148c8"
	chat_color = "#828cff"
	background_icon = "background_upp_delta"

/datum/squad/upp/kdo
	name = SQUAD_UPP_5
	equipment_color = "#c47a50"
	chat_color = "#c47a50"
	squad_type = "Team"
	locked = TRUE
	usable = FALSE

//###############################
/datum/squad/pmc
	name = "Root"
	squad_type = "Team"
	faction = FACTION_PMC
	usable = TRUE
	omni_squad_vendor = TRUE

/datum/squad/pmc/one
	name = "Team Upsilon"
	equipment_color = "#c864c8"
	chat_color = "#ff96ff"

/datum/squad/pmc/two
	name = "Team Gamma"
	equipment_color = "#c47a50"
	chat_color = "#c47a50"

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
		var/obj/structure/supply_drop/S = i
		if(name == S.squad)
			drop_pad = S
			break

/// Sets an overwatch officer for the squad, returning TRUE on success
/datum/squad/proc/assume_overwatch(mob/target_mob)
	var/mob/previous
	if(overwatch_officer)
		if(overwatch_officer == target_mob)
			return FALSE
		previous = overwatch_officer
		overwatch_officer = null
		clear_ref_tracking(previous)
	overwatch_officer = target_mob
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
/datum/squad/proc/clear_ref_tracking(mob/target_mob)
	if(!target_mob)
		return FALSE
	if(target_mob in marines_list)
		return FALSE
	if(overwatch_officer == target_mob)
		return FALSE
	UnregisterSignal(target_mob, COMSIG_PARENT_QDELETING)
	return TRUE

/// Clear references in squad listing upon deletion. Zap also erases the kept records.
/// NOTE: zap will be set true for a forced COMSIG_PARENT_QDELETING
/datum/squad/proc/personnel_deleted(mob/target_mob, zap = FALSE)
	SIGNAL_HANDLER
	if(target_mob == overwatch_officer)
		overwatch_officer = null
	if(target_mob == squad_leader)
		squad_leader = null
	SStracking.stop_tracking(tracking_id, target_mob)
	if(zap)
		marines_list.Remove(target_mob)
		return
	var/idx = marines_list.Find(target_mob)
	if(idx)
		marines_list[idx] = target_mob.name // legacy behavior, replace mob ref index by name. very weird

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
		for(var/mob/target_mob in marines_list)
			if(!target_mob.stat && target_mob.client)
				targets += target_mob.client

	if(displayed_icon)
		message = "[icon2html(displayed_icon, targets, dir = null)] [message]"
	if(sfx)
		SSsound.queue(sfx, targets)
	to_chat(targets, html = message, type = MESSAGE_TYPE_RADIO)

/// Displays a message to squad members directly on the game map
/datum/squad/proc/send_maptext(text = "", title_text = "", only_leader = 0)
	var/message_color = chat_color
	if(only_leader)
		if(squad_leader)
			if(!squad_leader.stat && squad_leader.client)
				playsound_client(squad_leader.client, 'sound/effects/radiostatic.ogg', squad_leader.loc, 25, FALSE)
				squad_leader.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, message_color)
	else
		for(var/mob/living/carbon/human/marine in marines_list)
			if(!marine.stat && marine.client) //Only living and connected people in our squad
				playsound_client(marine.client, 'sound/effects/radiostatic.ogg', marine.loc, 25, FALSE)
				marine.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[title_text]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order, message_color)

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
				to_chat(SL, "[SPAN_BLUE("<B>SL Overwatch:</b> [nametext][text]")]", type = MESSAGE_TYPE_RADIO)
				return
	else
		for(var/mob/living/carbon/human/target_mob in marines_list)
			if(!target_mob.stat && target_mob.client) //Only living and connected people in our squad
				if(plus_name)
					target_mob << sound('sound/effects/tech_notification.ogg')
				to_chat(target_mob, "[SPAN_BLUE("<B>Overwatch:</b> [nametext][text]")]", type = MESSAGE_TYPE_RADIO)



//Straight-up insert a marine into a squad.
//This sets their ID, increments the total count, and so on. Everything else is done in job_controller.dm.
//So it does not check if the squad is too full already, or randomize it, etc.
/datum/squad/proc/put_marine_in_squad(mob/living/carbon/human/target_mob, obj/item/card/id/id_card)
	if(!istype(target_mob))
		return FALSE //Logic
	if(!usable)
		return FALSE
	if(!target_mob.job)
		return FALSE //Not yet
	if(target_mob.assigned_squad)
		return FALSE //already in a squad

	if(!id_card)
		id_card = target_mob.wear_id
		if(!id_card)
			id_card = target_mob.get_active_hand()

	if(!istype(id_card))
		return FALSE //No ID found

	var/assignment = target_mob.job
	var/paygrade

	var/list/extra_access = list()

	var/mob_role = GET_DEFAULT_ROLE(target_mob.job)
	switch(mob_role)
		if(JOB_SQUAD_ENGI)
			assignment = JOB_SQUAD_ENGI
			id_card.claimedgear = FALSE
		if(JOB_SQUAD_MEDIC)
			assignment = JOB_SQUAD_MEDIC
			id_card.claimedgear = FALSE
		if(JOB_SQUAD_SPECIALIST)
			assignment = JOB_SQUAD_SPECIALIST
		if(JOB_SQUAD_TEAM_LEADER)
			assignment = JOB_SQUAD_TEAM_LEADER
			target_mob.important_radio_channels += radio_freq
		if(JOB_SQUAD_SMARTGUN)
			assignment = JOB_SQUAD_SMARTGUN
		if(JOB_SQUAD_LEADER)
			if(squad_leader && GET_DEFAULT_ROLE(squad_leader.job) != JOB_SQUAD_LEADER) //field promoted SL
				var/old_lead = squad_leader
				demote_squad_leader() //replaced by the real one
				SStracking.start_tracking(tracking_id, old_lead)
			assignment = squad_type + " Leader"
			squad_leader = target_mob
			SStracking.set_leader(tracking_id, target_mob)
			SStracking.start_tracking("marine_sl", target_mob)

		if(JOB_UPP_ENGI)
			assignment = JOB_SQUAD_ENGI
			id_card.claimedgear = FALSE
		if(JOB_UPP_MEDIC)
			assignment = JOB_SQUAD_MEDIC
			id_card.claimedgear = FALSE
		if(JOB_UPP_SPECIALIST)
			assignment = JOB_SQUAD_SPECIALIST
		if(JOB_UPP_LEADER)
			if(squad_leader && GET_DEFAULT_ROLE(squad_leader.job) != JOB_UPP_LEADER) //field promoted SL
				var/old_lead = squad_leader
				demote_squad_leader() //replaced by the real one
				SStracking.start_tracking(tracking_id, old_lead)
			assignment = squad_type + " Leader"
			squad_leader = target_mob
			SStracking.set_leader(tracking_id, target_mob)
			SStracking.start_tracking("marine_sl", target_mob)

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
				squad_leader = target_mob
				SStracking.set_leader(tracking_id, target_mob)
				SStracking.start_tracking("marine_sl", target_mob)
				mob_role = JOB_SQUAD_LEADER
		if(JOB_MARINE_RAIDER_CMD)
			assignment = JOB_MARINE_RAIDER_CMD
			if(name == JOB_MARINE_RAIDER)
				assignment = "Officer"

	if(mob_role in roles_cap)
		roles_in[mob_role]++

	RegisterSignal(target_mob, COMSIG_PARENT_QDELETING, PROC_REF(personnel_deleted), override = TRUE)
	if(assignment != JOB_SQUAD_LEADER)
		SStracking.start_tracking(tracking_id, target_mob)

	count++ //Add up the tally. This is important in even squad distribution.

	if(GET_DEFAULT_ROLE(target_mob.job) != JOB_SQUAD_MARINE)
		log_admin("[key_name(target_mob)] has been assigned as [name] [target_mob.job]") // we don't want to spam squad marines but the others are useful

	marines_list += target_mob
	target_mob.assigned_squad = src //Add them to the squad
	id_card.access += (src.access + extra_access) //Add their squad access to their ID
	if(prepend_squad_name_to_assignment)
		id_card.assignment = "[name] [assignment]"
	else
		id_card.assignment = assignment

	SEND_SIGNAL(target_mob, COMSIG_SET_SQUAD)

	if(paygrade)
		id_card.paygrade = paygrade
	id_card.name = "[id_card.registered_name]'s [id_card.id_type] ([id_card.assignment])"

	var/obj/item/device/radio/headset/almayer/marine/headset = locate() in list(target_mob.wear_l_ear, target_mob.wear_r_ear)
	if(headset && radio_freq)
		headset.set_frequency(radio_freq)
	target_mob.update_inv_head()
	target_mob.update_inv_wear_suit()
	target_mob.update_inv_gloves()
	return TRUE

//proc used by the overwatch console to transfer marine to another squad
/datum/squad/proc/remove_marine_from_squad(mob/living/carbon/human/target_mob, obj/item/card/id/id_card)
	if(target_mob.assigned_squad != src)
		return //not assigned to the correct squad
	if(!istype(id_card))
		id_card = target_mob.get_idcard()
	if(!istype(id_card))
		return FALSE //Abort, no ID found

	id_card.access -= src.access
	id_card.assignment = target_mob.job
	id_card.name = "[id_card.registered_name]'s [id_card.id_type] ([id_card.assignment])"

	forget_marine_in_squad(target_mob)

//gracefully remove a marine from squad system, alive, dead or otherwise
/datum/squad/proc/forget_marine_in_squad(mob/living/carbon/human/target_mob)
	if(target_mob.assigned_squad.squad_leader == target_mob)
		if(GET_DEFAULT_ROLE(target_mob.job) != JOB_SQUAD_LEADER || GET_DEFAULT_ROLE(target_mob.job) != JOB_UPP_LEADER) //a field promoted SL, not a real one
			demote_squad_leader()
		else
			target_mob.assigned_squad.squad_leader = null
		update_squad_leader()
	else
		if(target_mob.assigned_fireteam)
			if(fireteam_leaders[target_mob.assigned_fireteam] == target_mob)
				unassign_ft_leader(target_mob.assigned_fireteam, TRUE, FALSE)
			unassign_fireteam(target_mob, FALSE)

	count--
	marines_list -= target_mob
	personnel_deleted(target_mob, zap = TRUE) // Free all refs and Zap it entierly as this is on purpose
	clear_ref_tracking(target_mob)
	update_free_mar()
	target_mob.assigned_squad = null

	var/slot_check = GET_DEFAULT_ROLE(target_mob.job)
	if(slot_check && !isnull(roles_cap[slot_check]))
		roles_in[slot_check]--

//proc for demoting current Squad Leader
/datum/squad/proc/demote_squad_leader(leader_killed)
	var/mob/living/carbon/human/old_lead = squad_leader

	SStracking.delete_leader(tracking_id)
	SStracking.stop_tracking("marine_sl", old_lead)

	squad_leader = null
	switch(faction)
		if (FACTION_UPP)
			switch(GET_DEFAULT_ROLE(old_lead.job))
				if(JOB_UPP_SPECIALIST)
					old_lead.comm_title = "Spec"
				if(JOB_UPP_ENGI)
					old_lead.comm_title = "Sapper"
				if(JOB_UPP_MEDIC)
					old_lead.comm_title = "Med"
				if(JOB_UPP_LEADER)
					if(!leader_killed)
						old_lead.comm_title = "MSzh"
				else
					old_lead.comm_title = "Sld"
			if(GET_DEFAULT_ROLE(old_lead.job) != JOB_UPP_LEADER || !leader_killed)
				var/obj/item/device/radio/headset/headset = old_lead.get_type_in_ears(/obj/item/device/radio/headset/distress/UPP)
				if(headset)
					for(var/obj/item/device/encryptionkey/upp/command/acting/key in headset.keys)
						headset.keys -= key
						qdel(key)
					headset.recalculateChannels()
		if (FACTION_MARINE)
			switch(GET_DEFAULT_ROLE(old_lead.job))
				if(JOB_SQUAD_SPECIALIST)
					old_lead.comm_title = "Spc"
				if(JOB_SQUAD_ENGI)
					old_lead.comm_title = "ComTech"
				if(JOB_SQUAD_MEDIC)
					old_lead.comm_title = "HM"
				if(JOB_SQUAD_TEAM_LEADER)
					old_lead.comm_title = "FTL"
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
				var/obj/item/device/radio/headset/almayer/marine/headset = old_lead.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
				if(headset)
					for(var/obj/item/device/encryptionkey/squadlead/acting/key in headset.keys)
						headset.keys -= key
						qdel(key)
					headset.recalculateChannels()
				var/obj/item/card/id/card = old_lead.get_idcard()
				if(card)
					card.access -= ACCESS_MARINE_LEADER
	REMOVE_TRAITS_IN(old_lead, TRAIT_SOURCE_SQUAD_LEADER)
	old_lead.hud_set_squad()
	old_lead.update_inv_head() //updating marine helmet leader overlays
	old_lead.update_inv_wear_suit()
	to_chat(old_lead, FONT_SIZE_BIG(SPAN_BLUE("You're no longer the [squad_type] Leader for [src]!")))

//Not a safe proc. Returns null if squads or jobs aren't set up.
//Mostly used in the marine squad console in marine_consoles.dm.
/proc/get_squad_by_name(text)
	if(!GLOB.RoleAuthority || length(GLOB.RoleAuthority.squads) == 0)
		return null
	var/datum/squad/S
	for(S in GLOB.RoleAuthority.squads)
		if(S.name == text)
			return S
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
/datum/squad/proc/assign_fireteam(fireteam, mob/living/carbon/human/H, upd_ui = TRUE)
	if(H.assigned_fireteam)
		if(fireteam_leaders[H.assigned_fireteam])
			if(fireteam_leaders[H.assigned_fireteam] == H)
				unassign_ft_leader(H.assigned_fireteam, TRUE) //remove marine from TL position
			else
				SStracking.stop_tracking(H.assigned_fireteam, H) //remove from previous FT group
				if(H.stat == CONSCIOUS)
					to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was unassigned from your fireteam.")))
		fireteams[H.assigned_fireteam].Remove(H)
		var/ft = H.assigned_fireteam
		H.assigned_fireteam = fireteam
		fireteams[fireteam].Add(H) //adding to fireteam
		update_fireteam(ft)
		update_fireteam(fireteam)
		if(fireteam_leaders[fireteam]) //if TL exists -> FT group, otherwise -> SL group
			SStracking.start_tracking(fireteam, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Fireteam Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was assigned to your fireteam.")))
		else
			SStracking.start_tracking(tracking_id, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	else
		fireteams[fireteam].Add(H)
		H.assigned_fireteam = fireteam //adding to fireteam
		update_fireteam(fireteam)
		update_free_mar()
		if(fireteam_leaders[fireteam])
			SStracking.stop_tracking(tracking_id, H) //remove from previous FT group
			SStracking.start_tracking(fireteam, H)
			if(H.stat == CONSCIOUS)
				to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam]. Report to your Fireteam Leader ASAP.")))
			to_chat(fireteam_leaders[fireteam], FONT_SIZE_BIG(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was assigned to your fireteam.")))
		if(H.stat == CONSCIOUS)
			to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned to [fireteam].")))
	H.hud_set_squad()

/datum/squad/proc/unassign_fireteam(mob/living/carbon/human/H, upd_ui = TRUE)
	fireteams[H.assigned_fireteam].Remove(H)
	var/ft = H.assigned_fireteam
	H.assigned_fireteam = 0
	update_fireteam(ft)
	update_free_mar()
	if(fireteam_leaders[ft])
		SStracking.stop_tracking(ft, H) //remove from FT group
		SStracking.start_tracking(tracking_id, H) //add to SL group
		to_chat(fireteam_leaders[ft], FONT_SIZE_HUGE(SPAN_BLUE("[H.mind ? H.comm_title : ""] [H] was unassigned from your fireteam.")))
	if(!H.stat)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned from [ft].")))
	H.hud_set_squad()

/datum/squad/proc/assign_ft_leader(fireteam, mob/living/carbon/human/H, upd_ui = TRUE)
	if(fireteam_leaders[fireteam])
		unassign_ft_leader(fireteam, FALSE, FALSE)
	fireteam_leaders[fireteam] = H
	H.hud_set_squad()
	update_fireteam(fireteam)
	SStracking.set_leader(H.assigned_fireteam, H) //Set FT leader as leader of this group
	SStracking.start_tracking("marine_sl", H)
	if(H.stat == CONSCIOUS)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were assigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_ft_leader(fireteam, clear_group_id, upd_ui = TRUE)
	if(!fireteam_leaders[fireteam])
		return
	var/mob/living/carbon/human/H = fireteam_leaders[fireteam]
	fireteam_leaders[fireteam] = null
	H.hud_set_squad()
	if(clear_group_id)
		reassign_ft_tracker_group(fireteam, H.assigned_fireteam, tracking_id) //transfer whole FT to SL group
		update_fireteam(fireteam)
	if(!H.stat)
		to_chat(H, FONT_SIZE_HUGE(SPAN_BLUE("You were unassigned as [fireteam] Team Leader.")))

/datum/squad/proc/unassign_all_ft_leaders()
	for(var/team in fireteam_leaders)
		if(fireteam_leaders[team])
			unassign_ft_leader(team, TRUE, TRUE)

/datum/squad/proc/reassign_ft_tracker_group(fireteam, old_id, new_id)
	for(var/mob/living/carbon/human/H in fireteams[fireteam])
		SStracking.stop_tracking(old_id, H)
		SStracking.start_tracking(new_id, H)

//moved the main proc for ft management from human.dm here to make it support both examine and squad info way to edit fts
/datum/squad/proc/manage_fireteams(mob/living/carbon/human/target_mob)
	var/obj/item/card/id/ID = target_mob.get_idcard()

	if(!ID || ((!(ID.rank in GLOB.ROLES_MARINES) && faction == FACTION_MARINE) || (!(ID.rank in GLOB.ROLES_MARINES_ANTAG) && faction == FACTION_UPP)))
		return
	if(ID.rank == JOB_SQUAD_LEADER || squad_leader == target_mob) //if SL/aSL are chosen
		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign Fireteam 1 Leader", "Unassign Fireteam 2 Leader", "Unassign Fireteam 3 Leader", "Unassign all Team Leaders"))
		if(target_mob.assigned_squad != src)
			return //in case they somehow change squad while SL is choosing
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return //if SL got knocked out or demoted while choosing
		switch(choice)
			if("Unassign Fireteam 1 Leader")
				unassign_ft_leader("FT1", TRUE)
			if("Unassign Fireteam 2 Leader")
				unassign_ft_leader("FT2", TRUE)
			if("Unassign Fireteam 3 Leader")
				unassign_ft_leader("FT3", TRUE)
			if("Unassign all Team Leaders")
				unassign_all_ft_leaders()
			else
				return
		target_mob.hud_set_squad()
		return
	if(target_mob.assigned_fireteam)
		if(fireteam_leaders[target_mob.assigned_fireteam] == target_mob) //Check if person already is FT leader
			var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Unassign from Team Leader position"))
			if(target_mob.assigned_squad != src)
				return
			if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
				return
			if(choice == "Unassign from Team Leader position")
				unassign_ft_leader(target_mob.assigned_fireteam, TRUE)
			target_mob.hud_set_squad()
			return

		var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Remove from Fireteam", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3", "Assign as Team Leader"))
		if(target_mob.assigned_squad != src)
			return
		if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
			return
		switch(choice)
			if("Remove from Fireteam")
				unassign_fireteam(target_mob)
			if("Assign to Fireteam 1")
				assign_fireteam("FT1", target_mob)
			if("Assign to Fireteam 2")
				assign_fireteam("FT2", target_mob)
			if("Assign to Fireteam 3")
				assign_fireteam("FT3", target_mob)
			if("Assign as Team Leader")
				assign_ft_leader(target_mob.assigned_fireteam, target_mob)
			else
				return
		target_mob.hud_set_squad()
		return

	var/choice = tgui_input_list(squad_leader, "Manage Fireteams and Team leaders.", "Fireteams Management", list("Cancel", "Assign to Fireteam 1", "Assign to Fireteam 2", "Assign to Fireteam 3"))
	if(target_mob.assigned_squad != src)
		return
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return
	switch(choice)
		if("Assign to Fireteam 1")
			assign_fireteam("FT1", target_mob)
		if("Assign to Fireteam 2")
			assign_fireteam("FT2", target_mob)
		if("Assign to Fireteam 3")
			assign_fireteam("FT3", target_mob)
		else
			return
	target_mob.hud_set_squad()
	return

//Managing MIA and KIA statuses for marines
/datum/squad/proc/change_squad_status(mob/living/carbon/human/target_mob)
	if(target_mob == squad_leader)
		return //you can't mark yourself KIA
	var/choice = tgui_input_list(squad_leader, "Marine status management: M.I.A. for missing marines, K.I.A. for confirmed unrevivable dead.", "Squad Management", list("Cancel", "Remove status", "M.I.A.", "K.I.A."))
	if(target_mob.assigned_squad != src)
		return //in case they somehow change squad while SL is choosing
	if(squad_leader.is_mob_incapacitated() || !hasHUD(squad_leader,"squadleader"))
		return //if SL got knocked out or demoted while choosing
	switch(choice)
		if("Remove status")
			target_mob.squad_status = null
		if("M.I.A.")
			target_mob.squad_status = choice
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target_mob]'s status as Missing In Action.")))
			if(target_mob.stat == CONSCIOUS)
				to_chat(target_mob, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Missing In Action by Squad Leader.")))
		if("K.I.A.")
			target_mob.squad_status = choice
			if(target_mob.assigned_fireteam)
				if(fireteam_leaders[target_mob.assigned_fireteam] == target_mob)
					unassign_ft_leader(target_mob.assigned_fireteam, TRUE, FALSE)
				unassign_fireteam(target_mob, FALSE)
			to_chat(squad_leader, FONT_SIZE_BIG(SPAN_BLUE("You set [target_mob]'s status as Killed In Action. If they were Team Leader or in fireteam, they were demoted and unassigned.")))
			if(target_mob.stat == CONSCIOUS)
				to_chat(target_mob, FONT_SIZE_HUGE(SPAN_BLUE("You were marked as Killed In Action by Squad Leader.")))
		else
			return
	if(target_mob.assigned_fireteam)
		update_fireteam(target_mob.assigned_fireteam)
	else
		update_free_mar()
	target_mob.hud_set_squad()
	return
