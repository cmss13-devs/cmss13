GLOBAL_LIST_EMPTY(roundstart_leaders)

// THE MARINE TECH TREE
/datum/techtree/marine
	name = TREE_MARINE
	flags = TREE_FLAG_MARINE

	resource_icon_state = "node_marine"

	resource_make_sound = 'sound/machines/resource_node/node_marine_on.ogg'
	resource_destroy_sound = 'sound/machines/resource_node/node_marine_die_2.ogg'

	resource_break_sound = 'sound/effects/metalhit.ogg'

	resource_harvest_sound = 'sound/machines/resource_node/node_marine_harvest.ogg'

	resource_receive_process = TRUE

	var/last_pain_reduction = 0
	var/barricade_bonus_health = 100

	background_icon_locked = "marine"

	var/mob/living/carbon/human/leader
	var/mob/living/carbon/human/dead_leader
	var/job_cannot_be_overriden = list(
		JOB_XO,
		JOB_CO
	)

	var/faction = FACTION_MARINE

/datum/techtree/marine/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_POST_SETUP, .proc/setup_leader)

/datum/techtree/marine/proc/setup_leader(datum/source)
	SIGNAL_HANDLER
	if(length(GLOB.roundstart_leaders))
		transfer_leader_to(pick(GLOB.roundstart_leaders))

/datum/techtree/marine/generate_tree()
	. = ..()
	for(var/i in GLOB.tech_controls_marine)
		var/obj/structure/machinery/computer/tech_control/TC = i
		TC.attached_tree = src

/datum/techtree/marine/has_access(var/mob/M, var/access_required)
	switch(access_required)
		if(TREE_ACCESS_VIEW)
			if(M.faction == faction)
				return TRUE
		if(TREE_ACCESS_MODIFY)
			if(M == leader)
				return TRUE

	return FALSE

/datum/techtree/marine/can_attack(var/mob/living/carbon/H)
	return !ishuman(H)

/datum/techtree/marine/proc/apply_barricade_health(var/obj/structure/barricade/B)
	B.maxhealth += barricade_bonus_health
	B.update_health(-barricade_bonus_health)

#define LIGHT_OK 0
/datum/techtree/marine/on_node_gained(var/obj/structure/resource_node/RN)
	. = ..()

	RN.SetLuminosity(8)

	var/area/A = RN.controlled_area
	if(!A)
		return

	A.requires_power = FALSE
	A.unlimited_power = TRUE

	for(var/obj/structure/machinery/light/L in A.contents)
		L.status = LIGHT_OK
		L.update(0)

	A.update_power_channels(TRUE, TRUE, TRUE)

#undef LIGHT_OK

/datum/techtree/marine/on_node_lost(var/obj/structure/resource_node/RN)
	. = ..()

	RN.SetLuminosity(0)

	var/area/A = RN.controlled_area
	if(!A)
		return

	A.requires_power = TRUE
	A.unlimited_power = FALSE

	A.update_power_channels(FALSE, FALSE, FALSE)

/datum/techtree/marine/on_process(var/obj/structure/resource_node/RN)
	if(last_pain_reduction > world.time)
		return

	var/area/A = RN.controlled_area
	if(!A)
		return

	for(var/mob/living/carbon/human/H in A)
		H.pain.apply_pain_reduction(PAIN_REDUCTION_MULTIPLIER) // Level 1 painkilling chem

	last_pain_reduction = world.time + 1 SECONDS // Every second

/datum/techtree/marine/proc/transfer_leader_to(var/mob/living/carbon/human/H)
	if(!H)
		return
	remove_leader()

	RegisterSignal(H, COMSIG_MOVABLE_MOVED, .proc/handle_zlevel_check)
	RegisterSignal(H, COMSIG_MOB_DEATH, .proc/handle_death)

	leader = H

/datum/techtree/marine/proc/remove_leader()
	if(!leader)
		return
	UnregisterSignal(leader, list(
		COMSIG_MOB_DEATH,
		COMSIG_MOVABLE_MOVED
	))
	leader = null

/datum/techtree/marine/proc/handle_death(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if((H.job in job_cannot_be_overriden) && (!dead_leader || !dead_leader.check_tod()))
		RegisterSignal(H, COMSIG_PARENT_QDELETING, .proc/cleanup_dead_leader)
		RegisterSignal(H, COMSIG_HUMAN_REVIVED, .proc/readd_leader)
		dead_leader = H
	remove_leader()

/datum/techtree/marine/proc/cleanup_dead_leader(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if(dead_leader == H)
		dead_leader = null

/datum/techtree/marine/proc/readd_leader(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if(H != dead_leader)
		stack_trace("Non-leader attempted to be re-added back to command.")
		return
	remove_dead_leader()
	transfer_leader_to(H)

/datum/techtree/marine/proc/handle_zlevel_check(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER
	if(!is_mainship_level(H.z))
		remove_leader()

/datum/techtree/marine/proc/remove_dead_leader()
	if(!dead_leader)
		return

	UnregisterSignal(dead_leader, list(
		COMSIG_HUMAN_REVIVED,
		COMSIG_PARENT_QDELETING
	))
	dead_leader = null

GLOBAL_LIST_EMPTY(tech_controls_marine)

/obj/structure/machinery/computer/tech_control
	name = "tech control console"
	desc = "A console used to acquire the means to control the techtree."

	icon_state = "techweb"

	density = TRUE
	anchored = TRUE
	wrenchable = FALSE

	var/datum/techtree/marine/attached_tree

/obj/structure/machinery/computer/tech_control/Initialize()
	. = ..()
	GLOB.tech_controls_marine += src
	if(SStechtree.initialized)
		attached_tree = GET_TREE(TREE_MARINE)

/obj/structure/machinery/computer/tech_control/Destroy()
	GLOB.tech_controls_marine -= src
	attached_tree = null
	return ..()


// Disallow deconstructing
/obj/structure/machinery/computer/tech_control/attackby(obj/item/I, mob/user)
	return

/obj/structure/machinery/computer/tech_control/attack_hand(var/mob/M)
	. = ..()
	if(!attached_tree)
		return

	tgui_interact(M)

/obj/structure/machinery/computer/tech_control/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TechControl", name)
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/structure/machinery/computer/tech_control/ui_data(mob/user)
	. = list()

	var/mob/living/carbon/human/current_leader = attached_tree.leader
	if(current_leader)
		var/list/leaderdata = list(
			"name" = current_leader.name,
			"job" = current_leader.job,
		)

		var/datum/paygrade/P = GLOB.paygrades[current_leader.wear_id?.paygrade]
		if(P)
			leaderdata["paygrade"] = "[P.name] ([P.paygrade])"
			leaderdata["rank"] = P.ranking

		.["leader_data"] = leaderdata
	else
		.["leader_data"] = FALSE

	var/list/userdata = list(
		"name" = user.name,
		"job" = user.job,
		"is_leader" = (user == current_leader)
	)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/datum/paygrade/P = GLOB.paygrades[H.wear_id?.paygrade]
		if(P)
			userdata["paygrade"] = "[P.name] ([P.paygrade])"
			userdata["rank"] = P.ranking

	.["user_data"] = userdata


/obj/structure/machinery/computer/tech_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!ishuman(usr))
		return TRUE

	var/mob/living/carbon/human/H = usr

	switch(action)
		if("override_leader")
			var/mob/living/carbon/human/current_leader = attached_tree.leader
			if(!current_leader)
				to_chat(usr, SPAN_PURPLE("[icon2html(src)] Leadership status updated!"))
				attached_tree.transfer_leader_to(H)
				return TRUE

			if(current_leader == H)
				return TRUE

			if(current_leader.job in attached_tree.job_cannot_be_overriden)
				return TRUE

			var/datum/paygrade/p_leader = GLOB.paygrades[current_leader.wear_id?.paygrade]
			var/datum/paygrade/p_user = GLOB.paygrades[H.wear_id?.paygrade]
			if(!p_user)
				return TRUE

			if(!p_leader || p_user.ranking > p_leader.ranking)
				to_chat(usr, SPAN_PURPLE("[icon2html(src)] Leadership transfer complete!"))
				attached_tree.transfer_leader_to(H)
				return TRUE

		if("giveup_control")
			if(attached_tree.leader != H)
				return TRUE

			to_chat(usr, SPAN_PURPLE("[icon2html(src)] Leadership status revoked!"))
			attached_tree.remove_leader()
			return TRUE

/datum/admins/proc/remove_marine_techtree_leader()
	set name = "Remove Marine Techtree Leader"
	set desc = "Remove the marine's techtree leader"
	set category = "Admin.Game"

	if(!check_rights(R_MOD))
		return

	if(tgui_alert(usr, "Are you sure you want to remove the current techtree leader?",\
		"Remove techtree leader", list("No", "Yes")) == "No")
		return

	var/datum/techtree/marine/M = GET_TREE(TREE_MARINE)
	M.remove_dead_leader()
	M.remove_leader()
